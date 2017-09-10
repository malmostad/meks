module Reports
  class Economy < Workbooks
    def records
      @_records ||= begin
        Refugee.includes(
          :dossier_numbers, :ssns,
          :municipality, :payments, :gender,
          placements: [:legal_code, { home: %i[type_of_housings costs] }]
        ).with_placements_within(@from, @to)
      end
    end

    def selected_placements(refugee)
      refugee.placements_within(@from, @to)
    end

    def columns(refugee = Refugee.new, i = 0)
      [
        {
          heading: 'Dossiernummer',
          query: refugee.dossier_number
        },
        {
          heading: 'Extra dossiernummer',
          query: refugee.dossier_numbers.map(&:name).join(', ')
        },
        {
          heading: 'refugee.name',
          query: refugee.name
        },
        {
          heading: 'Personnummer',
          query: refugee.ssn
        },
        {
          heading: 'Extra personnummer',
          query: refugee.ssns.map(&:full_ssn).join(', ')
        },
        {
          heading: 'Lagrum',
          query: selected_placements(refugee).map(&:legal_code).map { |lc| lc.try(:name) }.reject(&:nil?).join(', ')
        },
        {
          heading: 'Alla boenden inom angivet datumintervall',
          query: selected_placements(refugee).map do |placement|
            "#{placement.home.name} (#{placement.moved_in_at}–#{placement.moved_out_at})"
          end.join(', ')
        },
        {
          heading: 'refugee.registered',
          query: refugee.registered,
          tooltip: 'Anger det datum då barnet registreras i MEKS för första gången'
        },
        {
          heading: 'Placeringsdatum',
          query: selected_placements(refugee).map(&:moved_in_at).compact.join(', ')
        },
        {
          heading: 'Utskrivningsdatum',
          query: selected_placements(refugee).map(&:moved_out_at).compact.join(', ')
        },
        {
          heading: 'refugee.deregistered',
          query: refugee.deregistered,
          tooltip: 'Anger datum för när socialtjänstansvaret för barnet är avslutat',
          type: :date
        },
        {
          heading: 'Boendeformer',
          query: selected_placements(refugee).map { |placement| placement.home.type_of_housings.map(&:name) }.join(', ')
        },
        {
          heading: 'refugee.municipality',
          query: refugee.municipality.try(:name)
        },
        {
          heading: 'refugee.municipality_placement_migrationsverket_at',
          query: refugee.municipality_placement_migrationsverket_at,
          type: :date
        },
        {
          heading: 'PUT',
          query: refugee.residence_permit_at,
          type: :date
        },
        {
          heading: 'refugee.checked_out_to_our_city',
          query: refugee.checked_out_to_our_city,
          tooltip: 'Det datum då barnet skrivs ut från Migrationsverket',
          type: :date
        },
        {
          heading: 'TUT startar',
          query: refugee.temporary_permit_starts_at,
          type: :date
        },
        {
          heading: 'TUT slutar',
          query: refugee.temporary_permit_ends_at,
          type: :date
        },
        {
          heading: 'refugee.citizenship_at',
          query: refugee.citizenship_at,
          type: :date
        },
        {
          heading: 'Budgeterad kostnad',
          query: self.class.costs_formula(refugee.placements_costs_and_days(from: @from, to: @to))
        },
        {
          heading: 'Förväntad schablon',
          query: refugee.expected_rate
        },
        {
          heading: 'Utbetald schablon',
          query: self.class.payments_formula(refugee.amount_and_days(from: @from, to: @to))
        },
        {
          heading: 'Ålder',
          query: refugee.age,
          type: :integer
        },
        {
          heading: 'refugee.gender',
          query: refugee.gender.try(:name)
        }
      ]
    end
  end
end
