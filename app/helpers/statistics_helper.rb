# Comments in Swedish are from project specifications
module StatisticsHelper
  # Samtliga personer som har angivet anvisningskommun med our_municipality: true
  # men som saknar datum för avslut
  def our_municipality_people
    Person.joins(:municipality).where(deregistered: nil, municipalities: { our_municipality: true })
  end

  def our_municipality_genders
    return [] if our_municipality_people.blank?

    our_municipality_people
      .group(:gender)
      .count.map do |key, value|
        next if key.blank?
        "#{value} är #{key.name.downcase}"
      end.reject(&:nil?)
  end

  # Samtliga personer som har our_municipality som anvisningskommun
  # men som saknar datum för avslut
  def top_countries
    our_municipality_people
      .joins(:countries).select('countries.name')
      .group('countries.name')
      .count('countries.name')
      .sort_by{ |key, value| value }.reject { |k, v| v <= 10  }.reverse[0...3].map(&:first).join(', ')
  end

  # Samtliga personer som har our_municipality som anvisningskommun
  # men som saknar datum för PUT, TUT eller medborgarskap.
  # Datum för avslut får inte vara ifyllt.
  def people_waiting_for_verdict
    our_municipality_people
      .where(temporary_permit_starts_at: nil)
      .where(residence_permit_at: nil)
      .where(citizenship_at: nil)
      .count
  end

  # Samtliga personer som har our_municipality som anvisningskommun
  # men som saknar datum för TUT eller medborgarskap.
  # Datum för avslut får inte vara ifyllt.
  def people_with_residence_permit
    our_municipality_people
      .where(temporary_permit_starts_at: nil)
      .where.not(residence_permit_at: nil)
      .where(citizenship_at: nil)
      .count
  end

  # Samtliga personer som har angivet anvisningskommun med our_municipality: true
  #   men som saknar datum för PUT eller medborgarskap.
  # Datum för avslut får inte vara ifyllt.
  def people_with_temporary_permit
    our_municipality_people
      .where.not(temporary_permit_starts_at: nil)
      .where(residence_permit_at: nil)
      .where(citizenship_at: nil)
      .count
  end

  # Samtliga personer som our_municipality angivet som anvisningskommun
  # och som har datum för medborgarskap ifyllt.
  # Datum för avslut får inte vara ifyllt.
  def people_with_citizenship
    our_municipality_people.where.not(citizenship_at: nil).count
  end

  # Samtliga personer som our_municipality angivet som anvisningskommun
  # och som inte har EKB
  def people_without_ekb
    our_municipality_people.where(ekb: false).count
  end

  # Samtliga personer som har angivet anvisningskommun med our_municipality: true
  # och som har aktuell placering på boendeform Institution och ägarform Kommunala (SRF)
  def people_on_hvb
    people_on_type_of_housing_and_owner_type(2, 1) # FIXME: hard coded
  end

  # Samtliga personer som har angivet anvisningskommun med our_municipality: true
  # och som har aktuell placering på boende med ägarformen "Extern placering".
  def externaly_placed_people
    people_on_type_of_housing_and_owner_type(nil, 3) # FIXME: hard coded
  end

  # Samtliga personer som har angivet anvisningskommun med our_municipality: true
  # och som har aktuell placering på boendeform "jourhem".
  def people_on_emergency_home
    people_on_type_of_housing_and_owner_type(3) # FIXME: hard coded
  end

  # Samtliga personer som har angivet anvisningskommun med our_municipality: true
  # och som har aktuell placering på boendeform "Familjehem".
  def people_on_family_home
    people_on_type_of_housing_and_owner_type(1) # FIXME: hard coded
  end

  # Samtliga personer som har angivet anvisningskommun med our_municipality: true
  # och som har aktuell placering på boendeform Stödboende och ägarform "Kommunala (SRF)"
  def people_on_outward_home
    people_on_type_of_housing_and_owner_type(5, 1) # FIXME: hard coded
  end

  # Samtliga personer som har angivet anvisningskommun med our_municipality: true
  # och som har aktuell placering på boendeform "Nätverkshem, outrett".
  def people_on_network_home_unprocessed
    people_on_type_of_housing_and_owner_type(8) # FIXME: hard coded
  end

  # Samtliga personer som har angivet anvisningskommun med our_municipality: true
  # och som har aktuell placering på boendeform "Nätverkshem, utrett".
  def people_on_network_home_processed
    people_on_type_of_housing_and_owner_type(9) # FIXME: hard coded
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

  # Comment in Swedish are from project specifications
  # Ankomstbarn typ 1:
  # - ska ha inskrivningsdatum
  # - ska inte ha anvisningskommun
  # - ska inte ha anvisningsdatum
  # - ska inte ha status avslutat
  # - ska inte datum för PUT
  # - ska inte datum för TUT
  # - ska inte datum för medborgarskap
  # - ska inte ha SoF-placering
  #
  # Ankomstbarn typ 2:
  # - ska ha inskrivningsdatum
  # - ska ha anvisningskommun
  # - ska ha anvisningsdatum där anvisningsdatumet ligger i framtiden
  # - ska inte ha status avslutat
  def in_arrival
    type1 = Person
            .where.not(registered: nil)
            .where(deregistered: nil)
            .where(municipality: nil)
            .where(municipality_placement_migrationsverket_at: nil)
            .where(residence_permit_at: nil)
            .where(temporary_permit_starts_at: nil)
            .where(citizenship_at: nil)
            .where(sof_placement: false)

    type2 = Person
            .where.not(registered: nil)
            .where.not(municipality: nil)
            .where('municipality_placement_migrationsverket_at > ?', Date.today)
            .where(deregistered: nil)

    (type1 + type2).uniq.size
  end

  private

  def people_on_type_of_housing_and_owner_type(type_of_housing_id = nil, owner_type_id = nil)
    return 0 unless type_of_housing_id || owner_type_id

    query = Placement
            .current_placements
            .joins(person: :municipality)
            .includes(:person, home: [:type_of_housings, :owner_type])
            .where(people: { municipalities: { our_municipality: true }, deregistered: nil })

    query = query.where(home: { type_of_housings: { id: type_of_housing_id } }) if type_of_housing_id
    query = query.where(home: { owner_types: { id: owner_type_id } }) if owner_type_id

    query.select(:person_id).distinct.count
  end
end
