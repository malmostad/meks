# Refugee has a `dossier_number` attribute, `dossier_numbers` are additional ones
class DossierNumber < ActiveRecord::Base
  belongs_to :refugee

  validates_uniqueness_of :name, case_sensitive: false
  validates_length_of :name, maximum: 191
end
