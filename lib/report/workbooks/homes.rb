class Report::Workbooks
  class Homes
    attr_accessor :record

    def initialize
      @record = Home.new
    end

    # The strucure is built to make it easy to re-arrange columns
    #   and still keep headings and data cells in sync with each other
    def columns
      [
        {
          heading: 'home.name',
          query: @record.name
        },
        {
          heading: 'home.phone',
          query: @record.phone
        },
        {
          heading: 'home.fax',
          query: @record.fax
        },
        {
          heading: 'home.address',
          query: @record.address
        },
        {
          heading: 'home.post_code',
          query: @record.post_code
        },
        {
          heading: 'home.postal_town',
          query: @record.postal_town
        },
        {
          heading: 'home.type_of_housings',
          query: @record.type_of_housings.map(&:name).join(', ')
        },
        {
          heading: 'home.owner_type',
          query: @record.owner_type.try(:name)
        },
        {
          heading: 'home.target_groups',
          query: @record.target_groups.map(&:name).join(', ')
        },
        {
          heading: 'home.languages',
          query: @record.languages.map(&:name).join(', ')
        },
        {
          heading: 'home.comment',
          query: @record.comment
        },
        {
          heading: 'Aktuella placeringar',
          query: @record.placements.select { |p| p.moved_out_at.nil? }.size,
          type: :integer
        },
        {
          heading: 'Placeringar totalt',
          query: @record.placements.count,
          type: :integer
        },
        {
          heading: 'Total placeringstid (dagar)',
          query: @record.total_placement_time,
          type: :integer
        },
        {
          heading: 'home.guaranteed_seats',
          query: @record.guaranteed_seats,
          type: :integer
        },
        {
          heading: 'Lediga platser',
          query: (@record.guaranteed_seats.to_i + @record.movable_seats.to_i) - @record.placements.select { |p| p.moved_out_at.nil?  }.size,
          type: :integer
        },
        {
          heading: 'home.movable_seats',
          query: @record.movable_seats,
          type: :integer
        },
        {
          heading: 'Summa platser',
          query: @record.seats,
          type: :integer
        },
        {
          heading: 'home.active',
          query: @record.active? ? 'Ja' : 'Nej'
        }
      ]
    end
  end
end
