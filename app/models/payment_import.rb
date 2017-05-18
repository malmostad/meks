class PaymentImport < ApplicationRecord
  belongs_to :user
  has_many :payments, dependent: :destroy

  validates_presence_of :user_id, :imported_at, :number_of_records
end
