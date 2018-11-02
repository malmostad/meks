# Comments in Swedish are from project specifications
module StatisticsHelper
  # Samtliga barn som har angivet anvisningskommun med our_municipality_department: true
  # men som saknar datum för avslut
  def our_municipality_department_refugees
    Refugee.where(deregistered: nil, our_municipality_department: true)
  end

  def our_municipality_department_genders
    return [] if our_municipality_department_refugees.blank?

    our_municipality_department_refugees
      .group(:gender)
      .count.map do |key, value|
        next if key.blank?
        "#{value} är #{key.name.downcase}"
      end.reject(&:nil?)
  end

  # Samtliga barn som har our_municipality_department som anvisningskommun
  # men som saknar datum för avslut
  def top_countries
    our_municipality_department_refugees
      .joins(:countries).select('countries.name')
      .group('countries.name')
      .count('countries.name')
      .sort_by{ |key, value| value }.reject { |k, v| v <= 10  }.reverse[0...3].map(&:first).join(', ')
  end

  # Samtliga barn som har our_municipality_department som anvisningskommun
  # men som saknar datum för PUT, TUT eller medborgarskap.
  # Datum för avslut får inte vara ifyllt.
  def refugees_waiting_for_verdict
    our_municipality_department_refugees
      .where(temporary_permit_starts_at: nil)
      .where(residence_permit_at: nil)
      .where(citizenship_at: nil)
      .count
  end

  # Samtliga barn som har our_municipality_department som anvisningskommun
  # men som saknar datum för TUT eller medborgarskap.
  # Datum för avslut får inte vara ifyllt.
  def refugees_with_residence_permit
    our_municipality_department_refugees
      .where(temporary_permit_starts_at: nil)
      .where.not(residence_permit_at: nil)
      .where(citizenship_at: nil)
      .count
  end

  # Samtliga barn som har angivet anvisningskommun med our_municipality_department: true
  #   men som saknar datum för PUT eller medborgarskap.
  # Datum för avslut får inte vara ifyllt.
  def refugees_with_temporary_permit
    our_municipality_department_refugees
      .where.not(temporary_permit_starts_at: nil)
      .where(residence_permit_at: nil)
      .where(citizenship_at: nil)
      .count
  end

  # Samtliga barn som our_municipality_department angivet som anvisningskommun
  # och som har datum för medborgarskap ifyllt.
  # Datum för avslut får inte vara ifyllt.
  def refugees_with_citizenship
    our_municipality_department_refugees.where.not(citizenship_at: nil).count
  end

  # Samtliga barn som har angivet anvisningskommun med our_municipality_department: true
  # och som har aktuell placering på boendeform somm heter Institution.
  def refugees_on_hvb
    Placement
      .current_placements
      .includes(:refugee, home: :type_of_housings)
      .where(refugees: { municipality: { our_municipality_department: true } })
      .where(home: { type_of_housings: { id: 2 } }) # FIXME: hard coded
      .select(:refugee_id).distinct.count
  end

  # Samtliga barn som har angivet anvisningskommun med our_municipality_department: true
  # och som har aktuell placering på boende med boendeform "Extern placering".
  def externaly_placed_refugees
    refugees_on_type_of_housing(6) # FIXME: hard coded
  end

  # Samtliga barn som har angivet anvisningskommun med our_municipality_department: true
  # och som har aktuell placering på boendeform "jourhem".
  def refugees_on_emergency_home
    refugees_on_type_of_housing(3) # FIXME: hard coded
  end

  # Samtliga barn som har angivet anvisningskommun med our_municipality_department: true
  # och som har aktuell placering på boendeform "Familjehem".
  def refugees_on_family_home
    refugees_on_type_of_housing(1) # FIXME: hard coded
  end

  # Samtliga barn som har angivet anvisningskommun med our_municipality_department: true
  # och som har aktuell placering på boendeform "Utsluss". Ändrat till Stödboende.
  def refugees_on_outward_home
    refugees_on_type_of_housing(5) # FIXME: hard coded
  end

  # Samtliga barn som har our_municipality: true och our_municipality_department: false
  # angivet som anvisningskommun och som har aktuell placering.
  def refugees_in_our_municipality_not_central_department_with_placement
    Refugee.with_current_placement.where(municipality: { our_municipality: true, our_municipality_department: false }).count
  end

  # Samtliga aktiva boenden med boendeform "Institution" samt "Utsluss".
  # Antalet boendeplatser räknas endast utifrån garantiplatser (ej inkluera rörliga platser).
  # Fetch from manual settings
  def number_of_homes
    Setting.where(key: 'number_of_homes').first&.value
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
      .where(refugees: { municipality: { our_municipality_department: true }, deregistered: nil })
      .select(:refugee_id).distinct.count
  end
end
