class ReportGenerator::Workbooks
  class Homes

    def initialize(home)
      @home = home
    end

    def headings
    end

    def queries
    end

    def styles
    end

    def tooltips
    end

    def formats
    end

    private

    def homes_data
      [
        {
          heading: "name",
          query: @home.name
        },
        {
          heading: "phone",
          query: @home.phone
        },
        {
          heading: "fax",
          query: @home.fax
        },
        {
          heading: "address",
          query: @home.address
        },
        {
          heading: "post_code",
          query: @home.post_code
        },
        {
          heading: "postal_town",
          query: @home.postal_town
        },
        {
          heading: "type_of_housings",
          query: @home.type_of_housings.map(&:name).join(', ')
        },
        {
          heading: "owner_type",
          query: @home.owner_type.name
        },
        {
          heading: "target_groups",
          query: @home.target_groups.map(&:name).join(', ')
        },
        {
          heading: "languages",
          query: @home.languages.map(&:name).join(', ')
        },
        {
          heading: "comment",
          query: @home.comment
        },
        {
          heading: "Aktuella placeringar",
          query: @home.placements.reject { |p| !p.moved_out_at.nil?  }.size,
          type: :integer
        },
        {
          heading: "Placeringar totalt",
          query: @home.placements.count,
          type: :integer
        },
        {
          heading: "Total placeringstid (dagar)",
          query: @home.total_placement_time,
          type: :integer
        },
        {
          heading: "guaranteed_seats",
          query: @home.guaranteed_seats,
          type: :integer
        },
        {
          heading: "Lediga platser",
          query: (@home.guaranteed_seats + @home.movable_seats) - @home.placements.reject { |p| !p.moved_out_at.nil?  }.size,
          type: :integer
        },
        {
          heading: "movable_seats",
          query: @home.movable_seats,
          type: :integer
        },
        {
          heading: "Summa platser",
          query: @home.seats,
          type: :integer
        },
        {
          heading: "active",
          query: @home.active? ? 'Ja' : 'Nej'
        }
      ]
    end
  end
end
