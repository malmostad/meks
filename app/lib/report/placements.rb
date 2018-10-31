module Report
  class Placements < Workbooks
    attr_accessor :record

    def initialize(options = {})
      super(options)
      @selection = options[:selection]
      @home_id = options[:home_id]
    end

    def records
      @_records ||= begin
        placements = Placement.includes(
          :home, :moved_out_reason, :legal_code,
          refugee: %i[countries languages ssns dossier_numbers
                      gender homes placements municipality
                      deregistered_reason],
          home: %i[languages type_of_housings placements
                   owner_type target_groups languages]
        ).within_range(@from, @to)

        # Selected one home or all
        if @home_id.present? && @home_id.reject(&:empty?).present?
          placements = placements.where(home_id: @home_id)
        end

        # Select overlapping placements per refugee
        if @selection == 'overlapping'
          placements = placements.overlapping_by_refugee(@from, @to)
        end
        placements
      end
    end

    def refugee_placements_within_range(refugee)
      records.map do |record|
        record if record.refugee.id == refugee.id
      end.compact.flatten
    end

    # The strucure is built to make it easy to re-arrange columns
    #   and still keep headings and data cells in sync with each other
    def columns(placement = Placement.new(refugee: Refugee.new, home: Home.new), i = 0)
      status = ::Economy::Status.new(placement.refugee)
      [
        {
          heading: 'Dossiernummer',
          query: placement.refugee.dossier_number
        },
        {
          heading: 'Extra dossiernummer',
          query: placement.refugee.dossier_numbers.map(&:name).join(', ')
        },
        {
          heading: 'Namn',
          query: placement.refugee.name
        },
        {
          heading: 'Personnummer',
          query: placement.refugee.ssn
        },
        {
          heading: 'Extra personnummer',
          query: placement.refugee.ssns.map(&:full_ssn).join(', ')
        },
        {
          heading: 'Boende',
          query: placement.home.name
        },
        {
          heading: 'Alla lagrum inom angivet datumintervall',
          query: refugee_placements_within_range(placement.refugee).map(&:legal_code).map(&:name).join(', '),
          tooltip: 'Lagrum för alla boenden som barnet varit placerat på under rapportens valda tidsintervall'
        },
        {
          heading: 'placement.specification',
          query: placement.specification,
          tooltip: 'Specificerar extern placering'
        },
        {
          heading: 'Alla boenden inom angivet datumintervall',
          query: refugee_placements_within_range(placement.refugee).map do |rp|
            "#{rp.home.name} (#{rp.moved_in_at}–#{rp.moved_out_at})"
          end.join(', '),
          tooltip: 'Alla boenden som barnet varit placerat på under rapportens valda tidsintervall'
        },
        {
          heading: 'refugee.registered',
          query: placement.refugee.registered,
          tooltip: 'Anger det datum då barnet registreras i MEKS för första gången',
          type: :date
        },
        {
          heading: 'placement.moved_in_at',
          query: placement.moved_in_at,
          tooltip: 'Anger det datum då barnet placeras på ett specifikt boende',
          type: :date
        },
        {
          heading: 'placement.moved_out_at',
          query: placement.moved_out_at,
          type: :date
        },
        {
          heading: 'placement.moved_out_reason',
          query: placement.moved_out_reason&.name
        },
        {
          heading: 'refugee.deregistered',
          query: placement.refugee.deregistered,
          tooltip: 'Anger datum för när socialtjänstansvaret för barnet är avslutat',
          type: :date
        },
        {
          heading: 'home.type_of_housings',
          query: placement.home.type_of_housings.map(&:name).join(', ')
        },
        {
          heading: 'refugee.municipality',
          query: placement.refugee.municipality&.name
        },
        {
          heading: 'refugee.municipality_placement_migrationsverket_at',
          query: placement.refugee.municipality_placement_migrationsverket_at,
          type: :date
        },
        {
          heading: 'refugee.sof_placement',
          query: placement.refugee.sof_placement ? 'Ja' : 'Nej'
        },
        {
          heading: 'refugee.municipality_placement_comment',
          query: placement.refugee.municipality_placement_comment
        },
        {
          heading: 'PUT',
          query: placement.refugee.residence_permit_at,
          type: :date
        },
        {
          heading: 'refugee.checked_out_to_our_city',
          query: placement.refugee.checked_out_to_our_city,
          tooltip: 'Det datum då barnet skrivs ut från Migrationsverket',
          type: :date
        },
        {
          heading: 'TUT startar',
          query: placement.refugee.temporary_permit_starts_at,
          type: :date
        },
        {
          heading: 'TUT slutar',
          query: placement.refugee.temporary_permit_ends_at,
          type: :date
        },
        {
          heading: 'refugee.citizenship_at',
          query: placement.refugee.citizenship_at,
          type: :date
        },
        {
          heading: 'Ålder',
          query: placement.refugee.age,
          type: :integer
        },
        {
          heading: 'refugee.gender',
          query: placement.refugee.gender&.name
        },
        {
          heading: 'refugee.countries',
          query: placement.refugee.countries.map(&:name).join(', ')
        },
        {
          heading: 'Språk (barn)',
          query: placement.refugee.languages.map(&:name).join(', ')
        },
        {
          heading: 'refugee.social_worker',
          query: placement.refugee.social_worker
        },
        {
          heading: 'refugee.special_needs',
          query: placement.refugee.special_needs? ? 'Ja' : 'Nej'
        },
        {
          heading: 'Total placeringstid (dagar)',
          query: placement.placement_time,
          type: :integer
        },
        {
          heading: 'refugee.deregistered_reason',
          query: placement.refugee.deregistered_reason&.name
        },
        {
          heading: 'refugee.deregistered_comment',
          query: placement.refugee.deregistered_comment
        },
        {
          heading: 'home.owner_type',
          query: placement.home.owner_type&.name
        },
        {
          heading: 'home.target_groups',
          query: placement.home.target_groups.map(&:name).join(', ')
        },
        {
          heading: 'Anledning till utskrivning',
          query: placement.moved_out_reason&.name
        },
        {
          heading: 'Asylstatus',
          query: status.format_asylum
        },
        {
          heading: 'home.phone',
          query: placement.home.phone
        },
        {
          heading: 'home.fax',
          query: placement.home.fax
        },
        {
          heading: 'home.address',
          query: placement.home.address
        },
        {
          heading: 'home.post_code',
          query: placement.home.post_code
        },
        {
          heading: 'home.postal_town',
          query: placement.home.postal_town
        },
        {
          heading: 'Språk (boende)',
          query: placement.home.languages.map(&:name).join(', ')
        },
        {
          heading: 'home.comment',
          query: placement.home.comment
        },
        {
          heading: 'home.guaranteed_seats',
          query: placement.home.guaranteed_seats,
          type: :integer
        },
        {
          heading: 'Lediga platser',
          query: (placement.home.guaranteed_seats.to_i + placement.home.movable_seats.to_i) - placement.home.placements.select { |p| p.moved_out_at.nil?  }.size,
          type: :integer
        },
        {
          heading: 'home.movable_seats',
          query: placement.home.movable_seats,
          type: :integer
        },
        {
          heading: 'Summa platser (garanti + rörliga)',
          query: placement.home.seats,
          type: :integer
        },
        {
          heading: 'home.active',
          query: placement.home.active? ? 'Ja' : 'Nej'
        }
      ]
    end
  end
end
