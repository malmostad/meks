RSpec.describe 'Home Cost calculations' do
  let(:refugee) { create(:refugee) }
  let(:cost) do
    create(
      :cost,
      start_date: '2018-01-01',
      end_date: '2018-12-31',
      amount: 1234
    )
  end

  let(:placement) do
    create(
      :placement,
      refugee: refugee,
      home: cost.home,
      moved_in_at: '2018-03-15',
      moved_out_at: '2018-06-20'
    )
  end

  before(:each) do
    refugee.reload
    cost.reload
    placement.reload
  end

  it 'should have correct total cost' do
    expect(Economy::PlacementAndHomeCost.new(refugee.placements).sum).to eq (97 + 1) * 1234
  end

  it 'should have a total cost limited by report interval' do
    expect(Economy::PlacementAndHomeCost.new(
      refugee.placements, from: '2018-02-01', to: '2018-03-31'
    ).sum).to eq (16 + 1) * 1234
  end
end
