class ReportGenerator::Workbooks
  def self.homes
    [
      {
        heading: "Foo",
        # query: todo,
        formula: true
      },
      {
        heading: "Bar",
        # query: todo,
        formula: true
      },
      {
        heading: "Form",
        # query: todo,
        formula: true
      },
      {
        heading: "name",
        # query: record.name
      },
      {
        heading: "phone",
        # query: record.phone
      },
      {
        heading: "fax",
        # query: record.fax
      },
      {
        heading: "address",
        # query: record.address
      },
      {
        heading: "post_code",
        # query: record.post_code
      },
      {
        heading: "postal_town",
        # query: record.postal_town
      },
      {
        heading: "type_of_housings",
        # query: record.type_of_housings.map(&:name).join(', ')
      },
      {
        heading: "owner_type",
        # query: record.owner_type.name
      },
      {
        heading: "target_groups",
        # query: record.target_groups.map(&:name).join(', ')
      },
      {
        heading: "languages",
        # query: record.languages.map(&:name).join(', ')
      },
      {
        heading: "comment",
        # query: record.comment
      },
      {
        heading: "Aktuella placeringar",
        # query: record.placements.reject { |p| !p.moved_out_at.nil?  }.size,
        type: :integer
      },
      {
        heading: "Placeringar totalt",
        # query: record.placements.count,
        type: :integer
      },
      {
        heading: "Total placeringstid (dagar)",
        # query: record.total_placement_time,
        type: :integer
      },
      {
        heading: "guaranteed_seats",
        # query: record.guaranteed_seats,
        type: :integer
      },
      {
        heading: "Lediga platser",
        # query: (record.guaranteed_seats + record.movable_seats) - record.placements.reject { |p| !p.moved_out_at.nil?  }.size,
        type: :integer
      },
      {
        heading: "movable_seats",
        # query: record.movable_seats,
        type: :integer
      },
      {
        heading: "Summa platser",
        # query: record.seats,
        type: :integer
      },
      {
        heading: "active",
        # query: record.active? ? 'Ja' : 'Nej'
      }
    ]
  end
end
