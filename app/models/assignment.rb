class Assignment < ActiveRecord::Base
  belongs_to :refugee
  belongs_to :home
end
