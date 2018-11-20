RSpec.describe 'FamilyAndEmergencyHomeCost' do
  let(:refugee) { create(:refugee) }
  let(:home) { create(:home, type_of_cost: :cost_for_family_and_emergency_home) }
  let(:placement) do
    create(
      :placement,
      refugee: refugee,
      home: home,
      moved_in_at: '2018-01-01',
      moved_out_at: '2018-12-31'
    )
  end
  let(:family_and_emergency_home_cost1) do
    create(
      :family_and_emergency_home_cost,
      period_start: '2018-01-01',
      period_end: '2018-06-30',
      fee: 12_345,
      expense: 23_456,
      placement: placement
    )
  end

  let(:family_and_emergency_home_cost2) do
    create(
      :family_and_emergency_home_cost,
      period_start: '2018-07-01',
      period_end: '2018-12-31',
      fee: 22_345,
      expense: 33_456,
      placement: placement
    )
  end

  before do
    [refugee, home, placement, family_and_emergency_home_cost1,
     family_and_emergency_home_cost2].each(&:reload)
  end

  it 'should have correct cost for a complete family_and_emergency_home_cost period' do
    costs = Economy::FamilyAndEmergencyHomeCost.new(
      refugee.placements,
      from: '2018-01-01',
      to: '2018-12-31'
    )
    expect(costs.sum).to eq 549_612
  end

  it 'should use default report range' do
    costs = Economy::FamilyAndEmergencyHomeCost.new(refugee.placements)
    expect(costs.sum).to be_a(Numeric)
  end

  it 'should have correct cost for a limiting full month report period' do
    costs = Economy::FamilyAndEmergencyHomeCost.new(
      refugee.placements,
      from: '2018-01-01',
      to: '2018-03-31'
    )
    expect(costs.sum).to eq 107_403
  end

  it 'should have correct cost for a limiting partial month report period' do
    costs = Economy::FamilyAndEmergencyHomeCost.new(
      refugee.placements,
      from: '2018-01-01',
      to: '2018-01-10'
    )
    expect(costs.sum.round).to eq 11_549
  end

  it 'should have correct cost for a limiting partial month report period exeeding placement time' do
    costs = Economy::FamilyAndEmergencyHomeCost.new(
      refugee.placements,
      from: '2017-01-01',
      to: '2019-01-10'
    )
    expect(costs.sum).to eq 549_612
  end

  it 'should have correct cost formula' do
    costs = Economy::FamilyAndEmergencyHomeCost.new(
      refugee.placements,
      from: '2018-01-01',
      to: '2018-01-10'
    )
    expect(costs.as_formula).to eq '0.3225806451612903*35801.0'
  end
end
