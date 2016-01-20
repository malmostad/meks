class Ssn < ActiveRecord::Base
  belongs_to :refugee

  validates :date_of_birth, format: { with: /\d{4}\-\d{2}\-\d{2}/,
      message: "Ogiltigt datumformat, måste vara yyyy-mm-dd" }

  def full_ssn
    date_of_birth.to_s.gsub('-', '') + '-' + extension.to_s
  end
end
