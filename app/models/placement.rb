class Placement < ActiveRecord::Base
  belongs_to :refugee
  belongs_to :home
  belongs_to :moved_out_reason

  validates_presence_of :home
end
