class Assignment < ActiveRecord::Base
  belongs_to :refugee
  belongs_to :home
  belongs_to :moved_out_reason
end
