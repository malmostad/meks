module Reports
  class Refugees < Workbooks
    attr_accessor :record

    def initialize
      @record = Refugee.new
    end

    # The strucure is built to make it easy to re-arrange columns
    #   and still keep headings and data cells in sync with each other
    def columns
      [
        {
          heading: 'refugee.name',
          query: @record.name
        },
        {
          heading: 'Personnummer',
          query: @record.ssn
        },
        {
          heading: 'Ålder',
          query: @record.age,
          type: :integer
        },
        {
          heading: 'Dossiernummer',
          query: @record.dossier_number
        },
        {
          heading: 'refugee.gender',
          query: @record.gender.try(:name)
        },
        {
          heading: 'refugee.countries',
          query: @record.countries.map(&:name).join(', ')
        },
        {
          heading: 'refugee.languages',
          query: @record.languages.map(&:name).join(', ')
        },
        {
          heading: 'refugee.registered',
          query: @record.registered,
          tooltip: 'Anger det datum då barnet registreras i MEKS för första gången'
        },
        {
          heading: 'Aktuellt boende',
          query: @record.current_placements.map(&:home).map(&:name).join(', ')
        },
        {
          heading: 'Aktuell boendeform',
          query: @record.current_placements.map { |cp| cp.home.type_of_housings.map  { |toh| toh.name  } }.join(', ')
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
          heading: 'refugee.sof_placement',
          query: @record.sof_placement ? 'Ja' : 'Nej'
        },
        {
          heading: 'refugee.municipality_placement_comment',
          query: @record.municipality_placement_comment
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
          heading: 'refugee.social_worker',
          query: @record.social_worker
        },
        {
          heading: 'refugee.special_needs',
          query: @record.special_needs? ? 'Ja' : 'Nej'
        },
        {
          heading: 'refugee.deregistered',
          query: @record.deregistered,
          tooltip: 'Anger datum för när socialtjänstansvaret för barnet är avslutat',
          type: :date
        },
        {
          heading: 'refugee.deregistered_reason',
          query: @record.deregistered_reason.try(:name)
        },
        {
          heading: 'refugee.deregistered_comment',
          query: @record.deregistered_comment
        },
        {
          heading: 'Alla boenden',
          query: @record.homes.map(&:name).join(', ')
        },
        {
          heading: 'Total placeringstid (dagar)',
          query: @record.total_placement_time,
          type: :integer
        },
        {
          heading: 'refugee.relateds',
          query: @record.relationships.map { |r| "#{r.refugee.name } (#{r.type_of_relationship.name })" }.join(', ')
        },
        {
          heading: 'Angiven som anhöriga till',
          query: @record.inverse_relationships.map { |r| "#{r.refugee.name } (#{r.type_of_relationship.name })"  }.join(', ')
        },
        {
          heading: 'Övriga anhöriga',
          query: @record.other_relateds
        },
        {
          heading: 'refugee.municipality_placement_per_agreement_at',
          query: @record.municipality_placement_per_agreement_at,
          type: :date
        },
        {
          heading: 'Asylstatus',
          query: Report.format_asylum_status(@record.asylum_status)
        },
        {
          heading: 'Extra personnummer',
          query: @record.ssns.map(&:full_ssn).join(', ')
        },
        {
          heading: 'Extra dossiernummer',
          query: @record.dossier_numbers.map(&:name).join(', ')
        }
      ]
    end
  end
end
