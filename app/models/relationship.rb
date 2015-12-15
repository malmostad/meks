class Relationship < ActiveRecord::Base
  belongs_to :refugee
  belongs_to :relative, class_name: 'Refugee'

  validates_presence_of :refugee_id
  validates_presence_of :relative_id
end
