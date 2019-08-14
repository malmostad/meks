RSpec.describe 'homes/show', type: :view do
  before(:each) do
    @home = assign(:home, create(:home))
  end

  it 'renders attributes for home' do
    render
    expect(rendered).to match(/#{@home.name}/)
    expect(rendered).to match(/#{@home.phone}/)
    expect(rendered).to match(/#{@home.fax}/)
    expect(rendered).to match(/#{@home.address}/)
    expect(rendered).to match(/#{@home.post_code}/)
    expect(rendered).to match(/#{@home.postal_town}/)
    expect(rendered).to match(/#{@home.type_of_housings.map(&:name).join(', ')}/)
    expect(rendered).to match(/#{@home.owner_type.present? ? @home.owner_type.name : ''}/)
    expect(rendered).to match(/#{@home.target_groups.map(&:name).join(', ')}/)
    expect(rendered).to match(/#{@home.languages.map(&:name).join(', ')}/)
    expect(rendered).to match(/#{@home.use_placement_specification? ? 'Ja' : 'Nej'}/)
    expect(rendered).to match(/#{@home.comment}/)
    expect(rendered).to match(/#{@placements.to_a.size}/)
    expect(rendered).to match(/#{@home.placements.count}/)
    expect(rendered).to match(/#{@home.total_placement_time}/)
    expect(rendered).to match(/#{@home.guaranteed_seats}/)
    expect(rendered).to match(/#{@placements.to_a.size}/)
    expect(rendered).to match(/#{@home.movable_seats}/)
    expect(rendered).to match(/#{@home.seats}/)
    expect(rendered).to match(/#{@home.active? ? 'Ja' : 'Nej'}/)
    expect(rendered).to match(/#{@home.costs.map(&:costs).join(', ')}/)
  end
end
