# Person has a `dossier_number` attribute, `dossier_numbers` are additional ones
# 'Dossiernummer'
class DossierNumber < ApplicationRecord
  belongs_to :person, touch: true

  validates_uniqueness_of :name, case_sensitive: false
  validates_length_of :name, maximum: 191
end
