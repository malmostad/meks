module Reports
  class Economy < Workbooks
    def initialize(options = {})
      super(options)
      @placements_within_range = placements_within_range
    end

    def records
      @placements_within_range.map(&:refugee)
    end

    def refugees_placements_within_range
      records.try(:map, &:placements)
    end

    def refugee_placements_within_range(refugee)
      @placements_within_range.map do |pl|
        pl if pl.refugee.id == refugee.id
      end.compact
    end

    def placements_within_range
      Placement.includes(
        :moved_out_reason, :legal_code,
        refugee: %i[countries languages ssns dossier_numbers
                    gender homes placements municipality
                    deregistered_reason payments],
        home: %i[languages type_of_housings
                 owner_type target_groups languages costs]
      ).within_range(@from, @to)
    end

    def columns(refugee = Refugee.new, i = 0)
      @refugee_placements = refugee_placements_within_range(refugee)
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
          query: @refugee_placements.map(&:legal_code).try(:map, &:name).join(', ')
        },
        {
          heading: 'Alla boenden inom angivet datumintervall',
          query: @refugee_placements.map do |pl|
            "#{pl.home.name} (#{pl.moved_in_at}–#{pl.moved_out_at})"
          end.join(', ')
        },
        {
          heading: 'refugee.registered',
          query: refugee.registered,
          tooltip: 'Anger det datum då barnet registreras i MEKS för första gången'
        },
        {
          heading: 'Placeringsdatum',
          query: @refugee_placements.map(&:moved_in_at).join(', ')
        },
        {
          heading: 'Utskrivningsdatum',
          query: @refugee_placements.map(&:moved_out_at).join(', ')
        },
        {
          heading: 'refugee.deregistered',
          query: refugee.deregistered,
          tooltip: 'Anger datum för när socialtjänstansvaret för barnet är avslutat',
          type: :date
        },
        {
          heading: 'Boendeformer',
          query: @refugee_placements
            .map(&:home)
            .try(:map, &:type_of_housings)
            .try(:map, &:name)
            .compact.join(', ')
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
          query: self.class.costs_formula(Refugee.placements_costs_and_days(@refugee_placements, from: @from, to: @to))
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
