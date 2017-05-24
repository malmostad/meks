# Validation messages are added to errors[:parse] for
#   parsing validations and, if none, standard validations
class PaymentImport < ApplicationRecord
  MINIMUM_FIELDS = 4

  belongs_to :user

  has_many :payments, dependent: :destroy
  accepts_nested_attributes_for :payments, allow_destroy: true
  validates_associated :payments

  validates_presence_of :user, :raw
  validate :pre_validation_errors

  after_rollback do
    # TODO: Log standard validation messages when errors[:parse]
    if errors[:parse].empty?
      error_id = Time.now.to_i
      logger.error "[ERROR_ID #{error_id}] An error occured when #{user.try(:username)} imported a payment file. #{errors.messages}"
      errors[:parse] << "Ett oväntat fel inträffade och har loggats. [Id: #{error_id}]"
    end
  end

  def parse(file, user)
    self.user = user
    # Change encoding and replace line linefeeds.
    self.raw = file.read.encode('UTF-8', universal_newline: true, invalid: :replace, undef: :replace, replace: '')
    self.content_type = file.content_type
    self.original_filename = file.original_filename
    self.imported_at = DateTime.now

    extract_payments
  end

  private

  def extract_payments
    rows = raw.split(/\n/)

    rows.each_with_index do |row, index|
      row_number = index + 1

      # Remove quotes around row
      row.strip.gsub!(/^"|"$/, '')

      # Split row into fields separated with colon or tab
      fields = row.split(/\s*[;\t]\s*/)

      next if fields.empty?

      if fields.size < MINIMUM_FIELDS
        parse_error "Raden innehåller för få fält. [rad #{row_number}]"
        next
      end

      # Split the date range field
      if fields[1].match?(/^\d{4}-\d{2}-\d{2}--\d{4}-\d{2}-\d{2}$/)
        period_start, period_end = fields[1].split(/\s*--\s*/)
      else
        parse_error "Perioden #{fields[1]} har inte korrekt format [rad #{row_number}]"
        next
      end

      payments << Payment.new(
        refugee_id: refugee_id_by_dossier_number(fields[0], row_number),
        period_start: period_start,
        period_end: period_end,
        amount_as_string: fields[2],
        diarie: fields[3]
      )
    end
  end

  def refugee_id_by_dossier_number(dossier_number, row_number)
    r = Refugee.where(dossier_number: dossier_number.strip).first
    if r.blank?
      parse_error "Inget barn hittades med dossiernumret #{dossier_number[0...25]} [rad #{row_number}]"
    else
      r.id
    end
  end

  # Set parse_errors
  def pre_validation_errors
    number_of_errors = @parse_errors.try(:size) || 0

    if number_of_errors > 15
      @parse_errors = @parse_errors[0...15]
      @parse_errors << "... ytterligare #{number_of_errors - 15} fel hittades."
    end

    errors[:parse] << @parse_errors
    errors[:parse].flatten!
  end

  def parse_error(msg)
    @parse_errors ||= []
    @parse_errors << msg
  end
end
