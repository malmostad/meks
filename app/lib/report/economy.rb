module Report
  # The rows in this spreadsheet are refugee centered.
  # Refugees that have one or more placements within the
  #   interval are collected.
  # Each selected refugee's row is populated with data
  #   containing all the refugee's placements within the interval
  #   and data related to those placements.
  # Formulas in the spreadsheet contains rates, costs, and payments
  #   associated with the refugee and it's placements within the interval.
  class Economy < Workbooks
    def initialize(options = {})
      super(options)
    end

    # Returns all refugees with placements within the interval
    def records
      Refugee.with_placements_within(@from, @to)
    end

    def columns(refugee = Refugee.new, i = 0)
      payment = ::Economy::Payment.new(refugee.payments, @interval)
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
          query: refugee.placements.sort_by(&:moved_in_at).map(&:legal_code).try(:map, &:name).join(', ')
        },
        {
          heading: 'Alla boenden inom angivet datumintervall',
          query: refugee.placements.sort_by(&:moved_in_at).map do |pl|
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
          query: refugee.placements.sort_by(&:moved_in_at).map(&:moved_in_at).compact.join(', ')
        },
        {
          heading: 'Utskrivningsdatum',
          query: refugee.placements.sort_by(&:moved_in_at).map(&:moved_out_at).compact.join(', ')
        },
        {
          heading: 'refugee.deregistered',
          query: refugee.deregistered,
          tooltip: 'Anger datum för när socialtjänstansvaret för barnet är avslutat',
          type: :date
        },
        {
          heading: 'refugee.deregistered_reason',
          query: refugee.deregistered_reason&.name
        },
        {
          heading: 'refugee.deregistered_comment',
          query: refugee.deregistered_comment
        },
        {
          heading: 'Boendeformer',
          query: refugee
            .placements
            .sort_by(&:moved_in_at)
            .map(&:home)
            .map(&:type_of_housings)
            .first
            .try(:map, &:name)
            .try(:compact)
            .try(:join, ', ')
        },
        {
          heading: 'refugee.municipality',
          query: refugee.municipality&.name
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
          query: self.class.sum_formula(
              ::Economy::PlacementAndHomeCost.new(refugee.placements, @interval).as_formula,
              ::Economy::ExtraContributionCost.new(refugee, @interval).as_formula,
              ::Economy::RefugeeExtraCost.new(refugee, @interval).as_formula
          ),
          style: 'currency'
        },
        {
          heading: 'Förväntad intäkt',
          query: self.class.sum_formula(::Economy::RatesForRefugee.new(refugee, @interval).as_formula),
          style: 'currency'
        },
        {
          heading: 'Utbetald schablon',
          query: self.class.sum_formula(payment.as_formula),
          style: 'currency'
        },
        {
          heading: 'Kommentarer till utbetalda schabloner',
          query: payment.comments.join("\r\x0D\x0A")
        },
        {
          heading: 'Ålder',
          query: refugee.age,
          type: :integer
        },
        {
          heading: 'refugee.gender',
          query: refugee.gender&.name
        },
        {
          heading: 'refugee.updated_at',
          query: refugee.updated_at.to_s[0..18]
        }
      ]
    end
  end
end
