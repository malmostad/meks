class Ssn < ActiveRecord::Base
  belongs_to :refugee

  def full_ssn
    date_of_birth.to_s.gsub('-', '') + '-' + extension.to_s
  end
end
