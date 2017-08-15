class Report::Workbooks
  class Economy
    attr_accessor :record

    def self.costs_formula(costs_and_days)
      calculation = costs_and_days.map do |cad|
        "(#{cad[:days]}*#{cad[:cost]})"
      end
      "=#{calculation.join('+')}"
    end

    def self.payments_formula(days_and_daily_amounts)
      calculation = days_and_daily_amounts.map do |dada|
        "(#{dada[:days]}*#{dada[:daily_amount]})"
      end
      "=#{calculation.join('+')}"
    end

    def initialize(range = {})
      @from = range[:from]
      @to = range[:to]
      @record = Refugee.new # Used when getting the headings
    end

    def selected_placements
      @record.placements_within(@from, @to)
    end

    # The strucure is built to make it easy to re-arrange columns
    #   and still keep headings and data cells in sync with each other
    def columns
      [
        {
          heading: 'Dossiernummer',
          query: @record.dossier_number
        },
        {
          heading: 'Extra dossiernummer',
          query: @record.dossier_numbers.map(&:name).join(', ')
        },
        {
          heading: 'refugee.name',
          query: @record.name
        },
        {
          heading: 'Personnummer',
          query: @record.ssn
        },
        {
          heading: 'Extra personnummer',
          query: @record.ssns.map(&:full_ssn).join(', ')
        },
        {
          heading: 'Lagrum',
          query: selected_placements.map(&:legal_code).map { |lc| lc.try(:name) }.reject(&:nil?).join(', ')
        },
        {
          heading: 'Alla boenden inom angivet datumintervall',
          query: selected_placements.map do |placement|
            "#{placement.home.name} (#{placement.moved_in_at}–#{placement.moved_out_at})"
          end.join(', ')
        },
        {
          heading: 'refugee.registered',
          query: @record.registered,
          tooltip: 'Anger det datum då barnet registreras i MEKS för första gången'
        },
        {
          heading: 'Placeringsdatum',
          query: selected_placements.map(&:moved_in_at).compact.join(', ')
        },
        {
          heading: 'Utskrivningsdatum',
          query: selected_placements.map(&:moved_out_at).compact.join(', ')
        },
        {
          heading: 'refugee.deregistered',
          query: @record.deregistered,
          tooltip: 'Anger datum för när socialtjänstansvaret för barnet är avslutat',
          type: :date
        },
        {
          heading: 'Boendeformer',
          query: selected_placements.map { |placement| placement.home.type_of_housings.map(&:name) }.join(', ')
        },
        {
          heading: 'refugee.municipality',
          query: @record.municipality.try(:name)
        },
        {
          heading: 'refugee.municipality_placement_migrationsverket_at',
          query: @record.municipality_placement_migrationsverket_at,
          type: :date
        },
        {
          heading: 'PUT',
          query: @record.residence_permit_at,
          type: :date
        },
        {
          heading: 'refugee.checked_out_to_our_city',
          query: @record.checked_out_to_our_city,
          tooltip: 'Det datum då barnet skrivs ut från Migrationsverket',
          type: :date
        },
        {
          heading: 'TUT startar',
          query: @record.temporary_permit_starts_at,
          type: :date
        },
        {
          heading: 'TUT slutar',
          query: @record.temporary_permit_ends_at,
          type: :date
        },
        {
          heading: 'refugee.citizenship_at',
          query: @record.citizenship_at,
          type: :date
        },
        {
          heading: 'Budgeterad kostnad',
          query: self.class.costs_formula(@record.placements_costs_and_days(from: @from, to: @to))
        },
        {
          heading: 'Förväntad schablon',
          query: @record.expected_rate
        },
        {
          heading: 'Utbetald schablon',
          query: self.class.payments_formula(@record.amount_and_days(from: @from, to: @to))
        },
        {
          heading: 'Ålder',
          query: @record.age,
          type: :integer
        },
        {
          heading: 'refugee.gender',
          query: @record.gender.try(:name)
        }
      ]
    end
  end
end
