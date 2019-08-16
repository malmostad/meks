# 'Utbetalda schabloner'
# Parsing a tab or semicolon separated csv file with on payment on each row.
# 4 mandatory and 1 optional field per row:
#   dossier_number, e.g. 123456
#   period_start, e.g. 20180618 or 2018-06-18
#   period_end, as period_start
#   amount, positive or negative float or integer as text, Swedish format -123,12, 321,54 or 789
#   comment, optional text
#
# All pre-saving parsing errors are added to errors[:parsing]
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
    # Log standard validation messages when pre-validation errors[:parsing] is empty
    if errors[:parsing].empty?
      error_id = Time.now.to_i
      logger.error "[ERROR_ID #{error_id}] An error occured when #{user&.username} imported a payment file. #{errors.messages}"
      errors[:parsing] << "Ett oväntat fel inträffade och har loggats. [Id: #{error_id}]"
    end
  end

  # Basic parsing of the uploaded file
  def parse(file, user)
    self.user = user
    # Read tempfile with correct encoding
    begin
      self.raw = File.open(file.path, 'r:bom|utf-8') { |f| f.read.gsub(/\r\n*/, "\n") }
    rescue => e
      logger.error "File upload error: #{e} #{file.content_type} #{file.original_filename}"
      parsing_error 'Filformatet gick inte att läsa'
    else
      self.content_type = file.content_type
      self.original_filename = file.original_filename
      self.imported_at = DateTime.now

      create_payments
    end
  end

  private

  # Parse the raw content of the file and create payments
  def create_payments
    valid_payments = parse_file

    logger.debug valid_payments

    valid_payments.each do |fields|
      logger.debug fields.except(:dossier_number, :row_number)
      payments << Payment.new(fields.except(:dossier_number, :row_number))
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

    person        = person_by_dossier_number(fields[0]) || return
    period_start   = parse_date(fields[1], row_number)                || return
    period_end     = parse_date(fields[2], row_number)                || return
    amount         = parse_amount(fields[3], row_number)              || return
    comment        = fields[4]

    { person_id: person.id,
      dossier_number: person.dossier_number,
      period_start: period_start,
      period_end: period_end,
      amount: amount,
      comment: comment,
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
      parsing_error "Raden innehåller för få fält. [rad #{row_number}]"
      return
    end
    fields
  end

  def person_by_dossier_number(str)
    dossier_number = str.gsub(/\D/, '')
    person = Person.where(dossier_number: dossier_number).first

    # Skip people not found or not #in_our_municipality?
    return unless person.present? && person.in_our_municipality?

    person
  end

  # Assumes the format YYYYMMDD and other characters like spaces and hyphens that will be removed
  def parse_date(str, row_number)
    date = str.gsub(/\D/, '')
    begin
      date.to_date
    rescue
      parsing_error "Datumet #{str} har inte korrekt format (ÅÅÅÅMMDD) [rad #{row_number}]"
      return
    end
  end

  def parse_amount(str, row_number)
    # Cleanup
    amount = str.gsub(/[^\d\-+,\.]/, '')
    # Change from Swedish to US float
    amount.gsub!(/,/, '.')
    unless amount.match(/\A[+-]?[\d\.]+\z/)
      parsing_error "Beloppet #{str} kunde inte tolkas [rad #{row_number}]"
      return
    end
    amount.to_f
  end

  def pre_validation_errors
    number_of_errors = @parsing_errors&.size || 0

    if number_of_errors > 15
      @parsing_errors = @parsing_errors[0...15]
      @parsing_errors << "... ytterligare #{number_of_errors - 15} fel hittades."
    end

    errors[:parsing] << @parsing_errors
    errors[:parsing].flatten!
    errors[:parsing].reject!(&:nil?)
  end

  def parsing_error(msg)
    @parsing_errors ||= []
    @parsing_errors << msg
  end
end
