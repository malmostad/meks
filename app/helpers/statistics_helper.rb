# Comments in Swedish are from project specifications
module StatisticsHelper
  # Samtliga barn med inskrivningsdatum, med eller utan datum för anvisningskommun ifyllt.
  # Anvisningskommun måste vara annan än Malmö SRF.
  # Datum för avslut får inte vara ifyllt.
  def registered
    Refugee.where.not(registered: nil)
      .where(deregistered: nil)
      .where(temporary_permit_starts_at: nil)
      .where(residence_permit_at: nil)
      .where(sof_placement: false)
      .where.not(municipality_id: 135) # 135 is hard wired to "Malmö kommun, Srf"
  end

  # Samtliga barn som har Malmö SRF angivet som anvisningskommun
  # men som saknar datum för avslut
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

  # Samtliga barn som har Malmö SRF angivet som anvisningskommun
  # men som saknar datum för avslut
  def top_countries
    srf.joins(:countries).select('countries.name')
      .group('countries.name')
      .count('countries.name')
      .sort_by{ |key, value| value }.reject { |k, v| v <= 10  }.reverse[0...3].map(&:first).join(', ')
  end

  # Samtliga barn som har Malmö SRF angivet som anvisningskommun
  # men som saknar datum för PUT, TUT eller medborgarskap.
  # Datum för avslut får inte vara ifyllt.
  def waiting_for_verdict
    srf.where(temporary_permit_starts_at: nil)
      .where(residence_permit_at: nil)
      .where(citizenship_at: nil)
  end

  # Samtliga barn som har Malmö SRF angivet som anvisningskommun
  # men som saknar datum för TUT eller medborgarskap.
  # Datum för avslut får inte vara ifyllt.
  def residence_permit
    srf.where(temporary_permit_starts_at: nil)
      .where(citizenship_at: nil)
  end

  # Samtliga barn som har Malmö SRF angivet som anvisningskommun
  #  men som saknar datum för PUT eller medborgarskap.
  # Datum för avslut får inte vara ifyllt.
  def temporary_permit
    srf.where(residence_permit_at: nil)
      .where(citizenship_at: nil)
  end

  # Samtliga barn som Malmö SRF angivet som anvisningskommun
  # och som har datum för medborgarskap ifyllt.
  # Datum för avslut får inte vara ifyllt.
  def citizenship
    srf.where.not(citizenship_at: nil)
  end

  # Samtliga barn som har Malmö SRF angivet som anvisningskommun
  # och som har aktuell placering på boende ägarform "Kommunala SRF" och "Privata SRF".
  # Datum för avslut får inte vara ifyllt.
  def on_hvb
    Placement.current_placements
      .includes(:refugee, home: :owner_type)
      .where(homes: { owner_type: 1  })
      .where(refugees: { municipality_id: 135, deregistered: nil }) # 135 is hard wired to "Malmö kommun, Srf"
      .select(:refugee_id).distinct.count
  end

  # Samtliga barn som har Malmö SRF angivet som anvisningskommun
  # och som har aktuell placering på boende med boendeform "Extern placering".
  def externaly_placed
    Placement.current_placements
      .includes(:refugee, home: :type_of_housings)
      .where(home: { type_of_housings: { id: 6 }}) # 6 is hard wired to type_of_housing with "boendeform Extern placering".
      .where(refugees: { municipality_id: 135, deregistered: nil }) # 135 is hard wired to "Malmö kommun, Srf"
      .select(:refugee_id).distinct.count
  end
end
