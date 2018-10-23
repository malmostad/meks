# 'Handläggare'
class User < ApplicationRecord
  has_many :payment_imports

  validates_presence_of :username
  validates_uniqueness_of :username, case_sensitive: false
  validates_presence_of :role
  validates_length_of :username, maximum: 191
  validates_length_of :name, maximum: 191
  validates_length_of :email, maximum: 191

  def has_role?(check_role)
    role == check_role.to_s
  end
end
