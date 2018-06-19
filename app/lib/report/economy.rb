module Report
  # The rows in this spreadsheet are refugee centered.
  # Refugees that have one or more placements within the
  #   range are collected.
  # Each selected refugee's row is populated with data
  #   containing all the refugee's placements within the range
  #   and data related to those placements.
  # Formulas in the spreadsheet contains rates, costs, and payments
  #   associated with the refugee and it's placements within the range.
  class Economy < Workbooks
    def initialize(options = {})
      super(options)
    end

    # Returns all refugees with placements within the range
    def records
      # Since each record is placement centered we get dublicates for each refugee.
      # Select uniq refugees
      placements_within_range.map(&:refugee).uniq
    end

    # Returns all placements within the range
    def placements_within_range
      @_placements_within_range ||= begin
        Placement.includes(
          :moved_out_reason, :legal_code,
          refugee: %i[countries languages ssns dossier_numbers
                      gender homes placements municipality
                      deregistered_reason payments],
          home: %i[languages type_of_housings
                   owner_type target_groups languages costs]
        ).within_range(@from, @to)
      end
    end

    # Returns a single refugee's all placements within the range
    def refugee_placements_within_range(refugee)
      placements_within_range.map do |pl|
        pl if pl.refugee.id == refugee.id
      end.compact
    end

    def columns(refugee = Refugee.new, i = 0)
      refugee_placements = refugee_placements_within_range(refugee)
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
          query: refugee_placements.map(&:legal_code).try(:map, &:name).join(', ')
        },
        {
          heading: 'Alla boenden inom angivet datumintervall',
          query: refugee_placements.map do |pl|
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
          query: refugee_placements.map(&:moved_in_at).join(', ')
        },
        {
          heading: 'Utskrivningsdatum',
          query: refugee_placements.map(&:moved_out_at).join(', ')
        },
        {
          heading: 'refugee.deregistered',
          query: refugee.deregistered,
          tooltip: 'Anger datum för när socialtjänstansvaret för barnet är avslutat',
          type: :date
        },
        {
          heading: 'Boendeformer',
          query: refugee_placements
            .map(&:home)
            .map(&:type_of_housings)
            .first
            .try(:map, &:name)
            .try(:compact)
            .try(:join, ', ')
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
          query: self.class.days_amount_formula(
            Statistics::Cost.placements_costs_and_days(refugee_placements, from: @from, to: @to)
          )
        },
        {
          heading: 'Förväntad schablon',
          query: self.class.days_amount_formula(
            Statistics::Rates.for_all_rate_categories(refugee, from: @from, to: @to)
          )
        },
        {
          heading: 'Utbetald schablon',
          query: self.class.days_amount_formula(
            Statistics::Payment.amount_and_days(refugee.payments, from: @from, to: @to)
          )
        },
        {
          heading: 'Kommentarer till utbetalda schabloner',
          query: Statistics::Payment.comments(refugee.payments, from: @from, to: @to).compact.join("\r\x0D\x0A")
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
