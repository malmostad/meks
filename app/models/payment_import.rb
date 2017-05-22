class PaymentImport < ApplicationRecord
  attr_accessor :file

  belongs_to :user

  has_many :payments, dependent: :destroy
  # accepts_nested_attributes_for :payments, allow_destroy: true
  # validates_associated :payments

  def parse(file, user)
    self.user_id = user.id
    self.raw = file.read.tr("\r", "\n")
    self.content_type = file.content_type
    self.original_filename = file.original_filename
    self.imported_at = DateTime.now
  end
end
