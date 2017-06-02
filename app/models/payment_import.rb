# All pre-saving parsing errors are added to errors[:parse]
# In the save phase, standard validations are logged
class PaymentImport < ApplicationRecord
  MINIMUM_FIELDS = 4

  belongs_to :user

  has_many :payments, dependent: :destroy
  accepts_nested_attributes_for :payments, allow_destroy: true
  validates_associated :payments

  validates_presence_of :user, :raw
  validate :pre_validation_errors

  after_rollback do
    # Log standard validation messages when pre-validation errors[:parse] is empty
    if errors[:parse].empty?
      error_id = Time.now.to_i
      logger.error "[ERROR_ID #{error_id}] An error occured when #{user.try(:username)} imported a payment file. #{errors.messages}"
      errors[:parse] << "Ett oväntat fel inträffade och har loggats. [Id: #{error_id}]"
    end
  end

  # Basic parsing of the uploaded file
  def parse(file, user)
    self.user = user
    # Change encoding and replace line linefeeds.
    # self.raw = file.read.encode('UTF-8', universal_newline: true, invalid: :replace, undef: :replace, replace: '')
    self.raw = File.open(file.path, 'r:bom|utf-8') { |f| f.read.gsub(/\r\n*/, "\n") }
    self.content_type = file.content_type
    self.original_filename = file.original_filename
    self.imported_at = DateTime.now

    create_payments
  end

  private

  # Parse the raw content of the file and create payments
  def create_payments
    valid_payments = parse_file

    valid_payments.each do |fields|
      payments << Payment.new(
        { refugee_id: refugee_id_by_dossier_number(fields) }
        .merge(fields.except(:dossier_number, :row_number))
      )
    end
  end

  def parse_file
    rows = raw.split(/\n/)
    valid_payments = []
    rows.each_with_index do |row, index|
      row_number = index + 1
      valid_payments << parse_row(row, row_number)
    end
    valid_payments.reject(&:blank?)
  end

  def parse_row(row, row_number)
    fields = extract_fields(row, row_number) || return
    dates = extract_dates(fields[1], row_number) || return

    { dossier_number: fields[0],
      period_start: dates[:start],
      period_end: dates[:end],
      amount_as_string: fields[2],
      diarie: fields[3],
      row_number: row_number }
  end

  def extract_fields(row, row_number)
    # Remove quotes around row
    row.strip.gsub!(/^"|"$/, '')

    # Split row into fields separated with colon or tab
    fields = row.split(/\s*[;\t]\s*/)

    # Blank row, ignore
    return if fields.empty?

    # Too few fields
    if fields.size < MINIMUM_FIELDS
      parse_error "Raden innehåller för få fält. [rad #{row_number}]"
      return
    end
    fields
  end

  # Split the date range field
  def extract_dates(str, row_number)
    if str.match?(/^\d{4}-\d{2}-\d{2}--\d{4}-\d{2}-\d{2}$/)
      d1, d2 = str.split(/\s*--\s*/)
    else
      parse_error "Perioden #{str} har inte korrekt format [rad #{row_number}]"
      return
    end
    { start: d1, end: d2 }
  end

  def refugee_id_by_dossier_number(fields)
    r = Refugee.where(dossier_number: fields[:dossier_number].strip).first
    if r.blank?
      parse_error "Inget barn hittades med dossiernumret #{fields[:dossier_number][0...25]} [rad #{fields[:row_number]}]"
    else
      r.id
    end
  end

  def pre_validation_errors
    number_of_errors = @parse_errors.try(:size) || 0

    if number_of_errors > 15
      @parse_errors = @parse_errors[0...15]
      @parse_errors << "... ytterligare #{number_of_errors - 15} fel hittades."
    end

    errors[:parse] << @parse_errors
    errors[:parse].flatten!
    errors[:parse].reject!(&:nil?)
  end

  def parse_error(msg)
    @parse_errors ||= []
    @parse_errors << msg
  end
end
