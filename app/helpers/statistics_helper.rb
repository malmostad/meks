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
  # och som har aktuell placering på boendeform somm heter Institution.
  def people_on_hvb
    Placement
      .current_placements
      .joins(person: :municipality)
      .includes(:person, home: :type_of_housings)
      .where(people: { municipalities: { our_municipality: true } })
      .where(home: { type_of_housings: { id: 2 } }) # FIXME: hard coded
      .select(:person_id).distinct.count
  end

  # Samtliga personer som har angivet anvisningskommun med our_municipality: true
  # och som har aktuell placering på boende med boendeform "Extern placering".
  def externaly_placed_people
    people_on_type_of_housing(6) # FIXME: hard coded
  end

  # Samtliga personer som har angivet anvisningskommun med our_municipality: true
  # och som har aktuell placering på boendeform "jourhem".
  def people_on_emergency_home
    people_on_type_of_housing(3) # FIXME: hard coded
  end

  # Samtliga personer som har angivet anvisningskommun med our_municipality: true
  # och som har aktuell placering på boendeform "Familjehem".
  def people_on_family_home
    people_on_type_of_housing(1) # FIXME: hard coded
  end

  # Samtliga personer som har angivet anvisningskommun med our_municipality: true
  # och som har aktuell placering på boendeform "Utsluss". Ändrat till Stödboende.
  def people_on_outward_home
    people_on_type_of_housing(5) # FIXME: hard coded
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

  def people_on_type_of_housing(id)
    Placement
      .current_placements
      .joins(person: :municipality)
      .includes(:person, home: :type_of_housings)
      .where(home: { type_of_housings: { id: id } })
      .where(people: { municipalities: { our_municipality: true }, deregistered: nil })
      .select(:person_id).distinct.count
  end
end
