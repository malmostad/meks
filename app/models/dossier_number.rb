class DossierNumber < ActiveRecord::Base
  belongs_to :refugee
  validates :name, length: { maximum: 191 }
end
