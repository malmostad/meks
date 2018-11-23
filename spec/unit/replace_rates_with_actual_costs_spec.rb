RSpec.describe Economy::ReplaceRatesWithActualCosts do
  let(:refugee) { create(:refugee) }
  let(:home) { create(:home, type_of_cost: :cost_per_placement) }
  let(:placement) do
    create(
      :placement_with_rate_exempt,
      refugee: refugee,
      home: home,
      moved_in_at: '2018-03-15',
      moved_out_at: '2018-06-20',
      cost: 1234
    )
  end

  before(:each) do
    refugee.reload
    home.reload
    placement.reload
  end

  it 'should calulate cost' do
    expect(Economy::ReplaceRatesWithActualCosts.new(refugee).sum).to eq((97 + 1) * 1234)
  end

  it 'should calulate cost limited by report interval' do
    expect(Economy::ReplaceRatesWithActualCosts.new(
      refugee, from: '2018-02-01', to: '2018-03-31'
    ).sum).to eq((16 + 1) * 1234)
  end

  it 'should return an array of days and amount as a string' do
    expect(Economy::ReplaceRatesWithActualCosts.new(refugee).as_formula).to eq '98*1234'
  end

  it 'should return an array of days and amount' do
    expect(Economy::ReplaceRatesWithActualCosts.new(refugee).as_array).to eq([days: 98, amount: 1234])
  end
end
