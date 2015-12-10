class Gender < ActiveRecord::Base
  validates :name, length: { maximum: 191 }
  has_many :refugees
end
