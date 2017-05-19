class PaymentImport < ApplicationRecord
  belongs_to :user

  has_many :payments, dependent: :destroy
  accepts_nested_attributes_for :payments, allow_destroy: true
  validates_associated :payments

  validates_presence_of :user_id, :imported_at, :number_of_records
end
