class Report::Workbooks
  class Placements
    attr_accessor :record

    def initialize
      @record = Placement.new(refugee: Refugee.new, home: Home.new)
    end

    # The strucure is built to make it easy to re-arrange columns
    #   and still keep headings and data cells in sync with each other
    def columns
      [
        {
          heading: 'Dossiernummer',
          query: @record.refugee.dossier_number
        },
        {
          heading: 'Extra dossiernummer',
          query: @record.refugee.dossier_numbers.map(&:name).join(', ')
        },
        {
          heading: 'Namn',
          query: @record.refugee.name
        },
        {
          heading: 'Personnummer',
          query: @record.refugee.ssn
        },
        {
          heading: 'Extra personnummer',
          query: @record.refugee.ssns.map(&:full_ssn).join(', ')
        },
        {
          heading: 'Boende',
          query: @record.home.name
        },
        {
          heading: 'placement.specification',
          query: @record.specification,
          tooltip: 'Specificerar extern placering'
        },
        {
          heading: 'Alla boenden inom angivet datumintervall',
          query: @record.refugee.placements.map do |p|
            "#{p.home.name} (#{Report.numshort_date(p.moved_in_at)}–#{Report.numshort_date(p.moved_out_at)})"
          end.reject(&:blank?).join(', '),
          tooltip: 'Alla boenden som barnet varit placerat på under rapportens valda tidsintervall'
        },
        {
          heading: 'refugee.registered',
          query: @record.refugee.registered,
          tooltip: 'Anger det datum då barnet registreras i MEKS för första gången',
          type: :date
        },
        {
          heading: 'placement.moved_in_at',
          query: @record.moved_in_at,
          tooltip: 'Anger det datum då barnet placeras på ett specifikt boende',
          type: :date
        },
        {
          heading: 'placement.moved_out_at',
          query: @record.moved_out_at,
          type: :date
        },
        {
          heading: 'placement.moved_out_reason',
          query: @record.moved_out_reason.try(:name)
        },
        {
          heading: 'refugee.deregistered',
          query: @record.refugee.deregistered,
          tooltip: 'Anger datum för när socialtjänstansvaret för barnet är avslutat',
          type: :date
        },
        {
          heading: 'home.type_of_housings',
          query: @record.home.type_of_housings.map(&:name).join(', ')
        },
        {
          heading: 'refugee.municipality',
          query: @record.refugee.municipality.try(:name)
        },
        {
          heading: 'refugee.municipality_placement_migrationsverket_at',
          query: @record.refugee.municipality_placement_migrationsverket_at,
          type: :date
        },
        {
          heading: 'refugee.sof_placement',
          query: @record.refugee.sof_placement ? 'Ja' : 'Nej'
        },
        {
          heading: 'refugee.municipality_placement_comment',
          query: @record.refugee.municipality_placement_comment
        },
        {
          heading: 'PUT',
          query: @record.refugee.residence_permit_at,
          type: :date
        },
        {
          heading: 'refugee.checked_out_to_our_city',
          query: @record.refugee.checked_out_to_our_city,
          tooltip: 'Det datum då barnet skrivs ut från Migrationsverket',
          type: :date
        },
        {
          heading: 'TUT startar',
          query: @record.refugee.temporary_permit_starts_at,
          type: :date
        },
        {
          heading: 'TUT slutar',
          query: @record.refugee.temporary_permit_ends_at,
          type: :date
        },
        {
          heading: 'refugee.citizenship_at',
          query: @record.refugee.citizenship_at,
          type: :date
        },
        {
          heading: 'Ålder',
          query: @record.refugee.age,
          type: :integer
        },
        {
          heading: 'refugee.gender',
          query: @record.refugee.gender.try(:name)
        },
        {
          heading: 'refugee.countries',
          query: @record.refugee.countries.map(&:name).join(', ')
        },
        {
          heading: 'Språk (barn)',
          query: @record.refugee.languages.map(&:name).join(', ')
        },
        {
          heading: 'refugee.social_worker',
          query: @record.refugee.social_worker
        },
        {
          heading: 'refugee.special_needs',
          query: @record.refugee.special_needs? ? 'Ja' : 'Nej'
        },
        {
          heading: 'Total placeringstid (dagar)',
          query: @record.placement_time,
          type: :integer
        },
        {
          heading: 'refugee.deregistered_reason',
          query: @record.refugee.deregistered_reason.try(:name)
        },
        {
          heading: 'refugee.deregistered_comment',
          query: @record.refugee.deregistered_comment
        },
        {
          heading: 'home.owner_type',
          query: @record.home.owner_type.try(:name)
        },
        {
          heading: 'home.target_groups',
          query: @record.home.target_groups.map(&:name).join(', ')
        },
        {
          heading: 'Anledning till utskrivning',
          query: @record.moved_out_reason.try(:name)
        },
        {
          heading: 'Asylstatus',
          query: Report.format_asylum_status(@record.refugee.asylum_status)
        },
        {
          heading: 'refugee.municipality_placement_per_agreement_at',
          query: @record.refugee.municipality_placement_per_agreement_at,
          type: :date
        },
        {
          heading: 'home.phone',
          query: @record.home.phone
        },
        {
          heading: 'home.fax',
          query: @record.home.fax
        },
        {
          heading: 'home.address',
          query: @record.home.address
        },
        {
          heading: 'home.post_code',
          query: @record.home.post_code
        },
        {
          heading: 'home.postal_town',
          query: @record.home.postal_town
        },
        {
          heading: 'Språk (boende)',
          query: @record.home.languages.map(&:name).join(', ')
        },
        {
          heading: 'home.comment',
          query: @record.home.comment
        },
        {
          heading: 'home.guaranteed_seats',
          query: @record.home.guaranteed_seats,
          type: :integer
        },
        {
          heading: 'Lediga platser',
          query: (@record.home.guaranteed_seats.to_i + @record.home.movable_seats.to_i) - @record.home.placements.select { |p| p.moved_out_at.nil?  }.size,
          type: :integer
        },
        {
          heading: 'home.movable_seats',
          query: @record.home.movable_seats,
          type: :integer
        },
        {
          heading: 'Summa platser (garanti + rörliga)',
          query: @record.home.seats,
          type: :integer
        },
        {
          heading: 'home.active',
          query: @record.home.active? ? 'Ja' : 'Nej'
        }
      ]
    end
  end
end
