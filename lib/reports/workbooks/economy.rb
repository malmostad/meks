module Reports
  class Economy < Workbooks
    class << self
      def costs_formula(costs_and_days)
        calculation = costs_and_days.map do |cad|
          "(#{cad[:days]}*#{cad[:cost]})"
        end
        "=#{calculation.join('+')}"
      end

      def payments_formula(days_and_daily_amounts)
        calculation = days_and_daily_amounts.map do |dada|
          "(#{dada[:days]}*#{dada[:daily_amount]})"
        end
        "=#{calculation.join('+')}"
      end
    end

    def header_row
      columns.map do |cell|
        { title: cell[:heading], tooltip: cell[:tooltip] }
      end
    end

    def header_tooltips
      columns.map do |cell|
        cell[:tooltip]
      end
    end

    def data_rows
      refugees.map do |refugee|
        columns(refugee).map do |cell|
          cell[:query]
        end
      end
    end

    def cell_data_types
      columns.map do |cell|
        cell[:type] || :string
      end
    end

    private

    def refugees
      Refugee.includes(
        :dossier_numbers, :ssns,
        :municipality,
        :gender, :homes, :municipality,
        current_placements: [home: :type_of_housings]
      ).where(registered: @from..@to)
    end

    # The strucure is built to make it easy to re-arrange columns
    #   and still keep headings and data cells in sync with each other
    def columns(refugee = Refugee.new)
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
          query: refugee.current_placements.map(&:legal_code).map { |lc| lc.try(:name) }.reject(&:nil?).join(', ')
        },
        {
          heading: 'Alla boenden inom angivet datumintervall',
          query: refugee.placements.map do |p|
            next unless p.refugee_id == refugee.id
            "#{p.home.name} (#{Reports.numshort_date(p.moved_in_at)}–#{Reports.numshort_date(p.moved_out_at)})"
          end.reject(&:blank?).join(', ')
        },
        {
          heading: 'refugee.registered',
          query: refugee.registered,
          tooltip: 'Anger det datum då barnet registreras i MEKS för första gången'
        },
        {
          heading: 'Placeringsdatum',
          query: refugee.current_placements.first.try(:moved_in_at)
        },
        {
          heading: 'Utskrivningsdatum',
          query: refugee.current_placements.first.try(:moved_out_at)
        },
        {
          heading: 'refugee.deregistered',
          query: refugee.deregistered,
          tooltip: 'Anger datum för när socialtjänstansvaret för barnet är avslutat',
          type: :date
        },
        {
          heading: 'Boendeformer',
          query: refugee.current_placements.map { |cp| cp.home.type_of_housings.map(&:name) }.join(', ')
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
