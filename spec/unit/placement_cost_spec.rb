RSpec.describe 'PlacementAndHomeCost calculations' do
  let(:interval) { { from: Date.new(0), to: Date.today } }
  let(:person) { create(:person) }
  let(:home) { create(:home, type_of_cost: :cost_per_placement) }
  let(:placement) do
    create(
      :placement,
      person: person,
      home: home,
      moved_in_at: '2018-03-15',
      moved_out_at: '2018-06-20',
      cost: 1234
    )
  end

  before(:each) do
    person.reload
    home.reload
    placement.reload
  end

  it 'should have correct total cost' do
    expect(Economy::PlacementAndHomeCost.new(person.placements, interval).sum).to eq((97 + 1) * 1234)
  end

  it 'should have a total cost limited by report interval' do
    expect(Economy::PlacementAndHomeCost.new(
      person.placements, from: '2018-02-01', to: '2018-03-31'
    ).sum).to(eq (16 + 1) * 1234)
  end

  it 'should return an array of days and amount as a string' do
    expect(Economy::PlacementAndHomeCost.new(person.placements, interval).as_formula).to eq '98*1234'
  end

  it 'should return an array of days and amount' do
    expect(Economy::PlacementAndHomeCost.new(person.placements, interval).as_array).to eq([days: 98, amount: 1234])
  end
end
