class Deassignment < ActiveRecord::Base
  belongs_to :refugee
  belongs_to :home
  has_one :deassignment_reason
end
