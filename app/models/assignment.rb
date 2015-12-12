class Assignment < ActiveRecord::Base
  belongs_to :refugee
  belongs_to :home
  has_one :moved_out_reason
end
