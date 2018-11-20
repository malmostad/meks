RSpec.describe 'PlacementAndHomeCost calculations' do
  let(:amount) { 1234 }
  let(:home) { create(:home) }
  let(:refugee) { create(:refugee) }
  let(:cost) { create(:cost, home: home, start_date: Date.today - 30, end_date: Date.today, amount: amount) }
  let(:placement) { create(:placement, moved_in_at: Date.today - 60, refugee: refugee, home: home) }

  before(:each) do
    home.reload
    refugee.reload
    cost.reload
    placement.reload
  end

  it 'should have an amount' do
    expect(cost.amount).not_to be nil
  end

  describe 'Cost calculations for a home type_of_cost set to cost_per_day' do
    it 'home should have a cost' do
      expect(home.costs.to_a.size).to eq 1
    end

    it 'refugee should have a total cost limited by cost range' do
      expect(Economy::PlacementAndHomeCost.new(refugee.placements).sum).to eq 37_020 + amount
    end

    it 'refugee should have a total cost limited by placement range' do
      cost = create(:cost, start_date: Date.today - 60, end_date: Date.today, amount: amount)
      refugee.placements << create(:placement, moved_in_at: Date.today - 30, home: cost.home)
      expect(Economy::PlacementAndHomeCost.new(refugee.placements).sum).to eq 37_020 + amount
    end
  end
end
