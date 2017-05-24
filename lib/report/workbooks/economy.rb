class Report::Workbooks
  class Economy
    attr_accessor :record

    def initialize(range = {})
      @record = Refugee.new
      @range_from = range[:from]
      @range_to = range[:to]
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
          query: @record.current_placements.map(&:legal_code).map { |lc| lc.try(:name) }.reject(&:nil?).join(', ')
        },
        {
          heading: 'Alla boenden inom angivet datumintervall',
          query: @record.placements.map do |p|
            next unless p.refugee_id == @record.id
            "#{p.home.name} (#{Report.numshort_date(p.moved_in_at)}–#{Report.numshort_date(p.moved_out_at)})"
          end.reject(&:blank?).join(', ')
        },
        {
          heading: 'refugee.registered',
          query: @record.registered,
          tooltip: 'Anger det datum då barnet registreras i MEKS för första gången'
        },
        {
          heading: 'Placeringsdatum',
          query: @record.current_placements.first.try(:moved_in_at)
        },
        {
          heading: 'Utskrivningsdatum',
          query: @record.current_placements.first.try(:moved_out_at)
        },
        {
          heading: 'refugee.deregistered',
          query: @record.deregistered,
          tooltip: 'Anger datum för när socialtjänstansvaret för barnet är avslutat',
          type: :date
        },
        {
          heading: 'Boendeformer',
          query: @record.current_placements.map { |cp| cp.home.type_of_housings.map(&:name) }.join(', ')
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
          query: Report::Workbooks.spreadsheet_formula(@record.placements_costs_and_days(from: @range_from, to: @range_to))
        },
        {
          heading: 'Förväntad schablon',
          query: @record.expected_rate
        },
        {
          heading: 'Utbetald schablon',
          query: @record.total_payments
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
