module Reports
  class Homes < Workbooks
    attr_accessor :record

    def initialize(options = {})
      super(options)
      @owner_type = options[:owner_type]
      @free_seats = options[:free_seats]
    end

    def header_row
      columns.map do |cell|
        { title: cell[:heading], tooltip: cell[:tooltip] }
      end
    end

    def data_rows
      homes.map do |home|
        columns(home).map do |cell|
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

    def homes
      homes = Home.includes(
        :placements, :type_of_housings,
        :owner_type, :target_groups, :languages
      )

      if @owner_type.present?
        homes = homes.where(owner_type: @owner_type)
      end

      if @free_seats == 'with'
        homes = homes.each.reject { |r| r.free_seats <= 0 }
      end
      homes
    end

    # The strucure is built to make it easy to re-arrange columns
    #   and still keep headings and data cells in sync with each other
    def columns(home = Home.new)
      [
        {
          heading: 'home.name',
          query: home.name
        },
        {
          heading: 'home.phone',
          query: home.phone
        },
        {
          heading: 'home.fax',
          query: home.fax
        },
        {
          heading: 'home.address',
          query: home.address
        },
        {
          heading: 'home.post_code',
          query: home.post_code
        },
        {
          heading: 'home.postal_town',
          query: home.postal_town
        },
        {
          heading: 'home.type_of_housings',
          query: home.type_of_housings.map(&:name).join(', ')
        },
        {
          heading: 'home.owner_type',
          query: home.owner_type.try(:name)
        },
        {
          heading: 'home.target_groups',
          query: home.target_groups.map(&:name).join(', ')
        },
        {
          heading: 'home.languages',
          query: home.languages.map(&:name).join(', ')
        },
        {
          heading: 'home.comment',
          query: home.comment
        },
        {
          heading: 'Aktuella placeringar',
          query: home.placements.select { |p| p.moved_out_at.nil? }.size,
          type: :integer
        },
        {
          heading: 'Placeringar totalt',
          query: home.placements.size,
          type: :integer
        },
        {
          heading: 'Total placeringstid (dagar)',
          query: home.total_placement_time,
          type: :integer
        },
        {
          heading: 'home.guaranteed_seats',
          query: home.guaranteed_seats,
          type: :integer
        },
        {
          heading: 'Lediga platser',
          query: (home.guaranteed_seats.to_i + home.movable_seats.to_i) - home.placements.select { |p| p.moved_out_at.nil?  }.size,
          type: :integer
        },
        {
          heading: 'home.movable_seats',
          query: home.movable_seats,
          type: :integer
        },
        {
          heading: 'Summa platser',
          query: home.seats,
          type: :integer
        },
        {
          heading: 'home.active',
          query: home.active? ? 'Ja' : 'Nej'
        }
      ]
    end
  end
end
