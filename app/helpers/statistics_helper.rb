# Comments in Swedish are from project specifications
module StatisticsHelper
  # Samtliga barn som har Malmö SRF angivet som anvisningskommun
  # men som saknar datum för avslut
  def srf_refugees
    Refugee
      .where(municipality_id: 135) # FIXME: hard coded
      .where(deregistered: nil)
  end

  def srf_genders
    return [] if srf_refugees.blank?

    srf_refugees
      .group(:gender)
      .count.map do |key, value|
        next if key.blank?
        "#{value} är #{key.name.downcase}"
      end.reject(&:nil?)
  end

  # Samtliga barn som har Malmö SRF angivet som anvisningskommun
  # men som saknar datum för avslut
  def top_countries
    srf_refugees
      .joins(:countries).select('countries.name')
      .group('countries.name')
      .count('countries.name')
      .sort_by{ |key, value| value }.reject { |k, v| v <= 10  }.reverse[0...3].map(&:first).join(', ')
  end

  # Samtliga barn som har Malmö SRF angivet som anvisningskommun
  # men som saknar datum för PUT, TUT eller medborgarskap.
  # Datum för avslut får inte vara ifyllt.
  def refugees_waiting_for_verdict
    srf_refugees
      .where(temporary_permit_starts_at: nil)
      .where(residence_permit_at: nil)
      .where(citizenship_at: nil)
      .count
  end

  # Samtliga barn som har Malmö SRF angivet som anvisningskommun
  # men som saknar datum för TUT eller medborgarskap.
  # Datum för avslut får inte vara ifyllt.
  def refugees_with_residence_permit
    srf_refugees
      .where(temporary_permit_starts_at: nil)
      .where.not(residence_permit_at: nil)
      .where(citizenship_at: nil)
      .count
  end

  # Samtliga barn som har Malmö SRF angivet som anvisningskommun
  #   men som saknar datum för PUT eller medborgarskap.
  # Datum för avslut får inte vara ifyllt.
  def refugees_with_temporary_permit
    srf_refugees
      .where.not(temporary_permit_starts_at: nil)
      .where(residence_permit_at: nil)
      .where(citizenship_at: nil)
      .count
  end

  # Samtliga barn som Malmö SRF angivet som anvisningskommun
  # och som har datum för medborgarskap ifyllt.
  # Datum för avslut får inte vara ifyllt.
  def refugees_with_citizenship
    srf_refugees.where.not(citizenship_at: nil).count
  end

  # Samtliga barn som har Malmö SRF angivet som anvisningskommun
  # och som har aktuell placering på boendeform somm heter Institution.
  def refugees_on_hvb
    Placement
      .current_placements
      .includes(:refugee, home: :type_of_housings)
      .where(refugees: { municipality_id: 135 }) # FIXME: hard coded
      .where(home: { type_of_housings: { id: 2 } }) # FIXME: hard coded
      .select(:refugee_id).distinct.count
  end

  # Samtliga barn som har Malmö SRF angivet som anvisningskommun
  # och som har aktuell placering på boende med boendeform "Extern placering".
  def externaly_placed_refugees
    refugees_on_type_of_housing(6) # FIXME: hard coded
  end

  # Samtliga barn som har Malmö SRF angivet som anvisningskommun
  # och som har aktuell placering på boendeform "jourhem".
  def refugees_on_emergency_home
    refugees_on_type_of_housing(3) # FIXME: hard coded
  end

  # Samtliga barn som har Malmö SRF angivet som anvisningskommun
  # och som har aktuell placering på boendeform "Familjehem".
  def refugees_on_family_home
    refugees_on_type_of_housing(1) # FIXME: hard coded
  end

  # Samtliga barn som har Malmö SRF angivet som anvisningskommun
  # och som har aktuell placering på boendeform "Utsluss".
  def refugees_on_outward_home
    refugees_on_type_of_housing(4) # FIXME: hard coded
  end

  # Samtliga barn som har Malmö Innerstaden, Malmö Väster, Malmö Norr, Malmö Öster eller Malmö Söder
  # angivet som anvisningskommun och som har aktuell placering.
  def refugees_in_malmo_sof_with_placement
    Refugee.with_current_placement
      .where(municipality_id: [136, 137, 138, 139, 140]) # FIXME: hard coded
      .count
  end

  # Samtliga aktiva boenden med boendeform "Institution" samt "Utsluss".
  # Antalet boendeplatser räknas endast utifrån garantiplatser (ej inkluera rörliga platser).
  # Fetch from manual settings
  def number_of_homes
    Setting.where(key: 'number_of_homes').first.try(:value)
  end

  def guaranteed_seats
    Home.where(active: true).sum(:guaranteed_seats)
  end

  private

  def refugees_on_type_of_housing(id)
    Placement
      .current_placements
      .includes(:refugee, home: :type_of_housings)
      .where(home: { type_of_housings: { id: id } })
      .where(refugees: { municipality_id: 135, deregistered: nil })  # FIXME: hard coded
      .select(:refugee_id).distinct.count
  end
end
