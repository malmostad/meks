# 'Procentsatser för arbetsgivaravgift, tidigare "PO-pålägg"'
# Used for calcuation of FamilyAndEmergencyHomeCost and ExtraContributionCost
class PoRate < ApplicationRecord
  default_scope { order(:start_date) }

  validates :rate_under_65, :rate_between_65_and_81, :rate_from_82, :start_date, :end_date, presence: true
  validates :rate_under_65, :rate_between_65_and_81, :rate_from_82, numericality: true
  validate do
    date_range(:start_date, start_date, end_date)
  end

  after_commit do
    Rails.cache.delete('PoRate/all')
  end

  def self.all_cached
    Rails.cache.fetch('PoRate/all') { all.load }
  end
end
