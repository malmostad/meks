module Report
  class Refugees < Workbooks
    def initialize(options = {})
      # Used for sheet name
      options[:from] = options[:registered_from]
      options[:to] = options[:registered_to]

      super(options)
      @registered_from = options[:registered_from]
      @registered_to = options[:registered_to]
      @born_after = options[:born_after]
      @born_before = options[:born_before]
      @include_without_date_of_birth = options[:include_without_date_of_birth]
      @asylum = options[:asylum]
    end

    def records
      refugees = Refugee.includes(
        :countries, :languages, :ssns, :dossier_numbers,
        :gender, :homes, :municipality, :deregistered_reason,
        relationships: %i[type_of_relationship refugee],
        inverse_relationships: %i[type_of_relationship refugee],
        current_placements: [home: :type_of_housings]
      )

      if @registered_from.present? && @registered_to.present?
        refugees = refugees.where(registered: @registered_from..@registered_to)
      end

      query = [(@born_after..@born_before)]
      query << nil if @include_without_date_of_birth

      if @born_after.present? && @born_before.present?
        refugees = refugees.where(date_of_birth: query)
      end

      if @asylum.present?
        query = []
        if @asylum.include? 'put'
          query << 'refugees.residence_permit_at is not null'
        end
        if @asylum.include? 'tut'
          query << 'refugees.temporary_permit_starts_at is not null'
        end
        if @asylum.include? 'municipality'
          query << 'refugees.municipality_id is not null'
        end
        refugees = refugees.where(query.join(' or '))
      end
      refugees
    end

    # The strucure is built to make it easy to re-arrange columns
    #   and still keep headings and data cells in sync with each other
    def columns(refugee = Refugee.new, i = 0)
      status = ::Economy::Status.new(refugee)
      [
        {
          heading: 'refugee.name',
          query: refugee.name
        },
        {
          heading: 'Personnummer',
          query: refugee.ssn
        },
        {
          heading: 'Ålder',
          query: refugee.age,
          type: :integer
        },
        {
          heading: 'Dossiernummer',
          query: refugee.dossier_number
        },
        {
          heading: 'refugee.gender',
          query: refugee.gender&.name
        },
        {
          heading: 'refugee.countries',
          query: refugee.countries.map(&:name).join(', ')
        },
        {
          heading: 'refugee.languages',
          query: refugee.languages.map(&:name).join(', ')
        },
        {
          heading: 'refugee.registered',
          query: refugee.registered,
          tooltip: 'Anger det datum då barnet registreras i MEKS för första gången'
        },
        {
          heading: 'Aktuellt boende',
          query: refugee.current_placements.map(&:home).map(&:name).join(', ')
        },
        {
          heading: 'Aktuell boendeform',
          query: refugee.current_placements.map { |cp| cp.home.type_of_housings.map  { |toh| toh.name  } }.join(', ')
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
          heading: 'refugee.sof_placement',
          query: refugee.sof_placement ? 'Ja' : 'Nej'
        },
        {
          heading: 'refugee.municipality_placement_comment',
          query: refugee.municipality_placement_comment
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
          heading: 'refugee.social_worker',
          query: refugee.social_worker
        },
        {
          heading: 'refugee.special_needs',
          query: refugee.special_needs? ? 'Ja' : 'Nej'
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
          heading: 'Alla boenden',
          query: refugee.homes.map(&:name).join(', ')
        },
        {
          heading: 'Total placeringstid (dagar)',
          query: refugee.total_placement_time,
          type: :integer
        },
        {
          heading: 'refugee.relateds',
          query: refugee.relationships.map { |r| "#{r.refugee.name} (#{r.type_of_relationship.name})" }.join(', ')
        },
        {
          heading: 'Angiven som anhöriga till',
          query: refugee.inverse_relationships.map { |r| "#{r.refugee.name} (#{r.type_of_relationship.name})" }.join(', ')
        },
        {
          heading: 'Övriga anhöriga',
          query: refugee.other_relateds
        },
        {
          heading: 'refugee.municipality_placement_per_agreement_at',
          query: refugee.municipality_placement_per_agreement_at,
          type: :date
        },
        {
          heading: 'Asylstatus',
          query: status.format_asylum
        },
        {
          heading: 'Extra personnummer',
          query: refugee.ssns.map(&:full_ssn).join(', ')
        },
        {
          heading: 'Extra dossiernummer',
          query: refugee.dossier_numbers.map(&:name).join(', ')
        },
        {
          heading: 'refugee.updated_at',
          query: refugee.updated_at.to_s[0..18]
        }
      ]
    end
  end
end
