class PaymentImport < ApplicationRecord
  attr_accessor :file

  belongs_to :user

  has_many :payments, dependent: :destroy
  accepts_nested_attributes_for :payments, allow_destroy: true
  validates_associated :payments

  def parse(file, user)
    self.user = user
    # Change encoding and replace line linefeeds.
    self.raw = file.read.encode('UTF-8', universal_newline: true, invalid: :replace, undef: :replace, replace: '')
    self.content_type = file.content_type
    self.original_filename = file.original_filename
    self.imported_at = DateTime.now

    extract_payments
  end

  def extract_payments
    raw.split(/\n/).each do |row|
      columns = row.split(/\s*[;\t]\s*/)
      period_start, period_end = columns[1].split(/\s*--\s*/)

      payments << Payment.new(
        refugee: Refugee.where(dossier_number: columns[0]).first,
        period_start: period_start,
        period_end: period_end,
        amount_as_string: columns[2],
        diarie: columns[3]
      )
    end
  end
end
