# 'Anhörig'
class Relationship < ApplicationRecord
  belongs_to :person, touch: true
  belongs_to :related, class_name: 'Person', touch: true
  belongs_to :type_of_relationship

  validates_presence_of :person_id
  validates_presence_of :related_id
  validates_presence_of :type_of_relationship_id

  validates :person_id, uniqueness: { scope: :related_id }
end
