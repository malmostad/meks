module StatisticsHelper
  def registered
    Refugee.where.not(registered: nil)
      .where(deregistered: nil)
      .where(temporary_permit_starts_at: nil)
      .where(residence_permit_at: nil)
      .where(sof_placement: false)
      .where.not(municipality_id: 135) # 135 is hard wired to "Malmö kommun, Srf"
  end

  def srf
    Refugee.where(municipality_id: 135) # 135 is hard wired to "Malmö kommun, Srf"
      .where(deregistered: nil)
  end

  def srf_women
    srf.where(gender_id: 1) # 1 is hardcoded women
  end

  def srf_men
    srf.where(gender_id: 2) # 2 is hardcoded men
  end

  def top_countries
    srf.joins(:countries).select('countries.name')
      .group('countries.name')
      .count('countries.name')
      .sort_by{ |key, value| value }.reject { |k, v| v <= 10  }.reverse[0...3].map(&:first).join(', ')
  end

  def waiting_for_verdict
    srf.where(temporary_permit_starts_at: nil)
      .where(residence_permit_at: nil)
      .where(citizenship_at: nil)
  end

  def residence_permit
    srf.where(temporary_permit_starts_at: nil)
      .where(citizenship_at: nil)
  end

  def temporary_permit
    srf.where(residence_permit_at: nil)
      .where(citizenship_at: nil)
  end

  def citizenship
    srf.where.not(citizenship_at: nil)
  end

  def on_hvb
    srf.includes(:placements).where(current_placements: { id: [1, 2] }) # hardcoded owner_types
  end
end
