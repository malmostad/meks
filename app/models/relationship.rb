class Relationship < ActiveRecord::Base
  belongs_to :refugee
  belongs_to :related, class_name: 'Refugee'
  belongs_to :type_of_relationship

  validates_presence_of :refugee_id
  validates_presence_of :related_id
  validates_presence_of :type_of_relationship_id

  validates :refugee_id, uniqueness: { scope: :related_id }
end
