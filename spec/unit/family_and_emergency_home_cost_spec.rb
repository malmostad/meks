RSpec.describe 'FamilyAndEmergencyHomeCost' do
  let(:interval) { { from: Date.new(0), to: Date.today } }
  let(:person) { create(:person) }
  let(:home) { create(:home, type_of_cost: :cost_for_family_and_emergency_home) }

  let(:placement) do
    create(
      :placement,
      person: person,
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
      placement: placement,
      contractor_birthday: '1980-01-15'
    )
  end

  let(:family_and_emergency_home_cost2) do
    create(
      :family_and_emergency_home_cost,
      period_start: '2018-07-01',
      period_end: '2018-12-31',
      fee: 22_345,
      expense: 33_456,
      placement: placement,
      contractor_birthday: '1950-01-15'
    )
  end

  let(:po_rate) do
    create(
      :po_rate,
      rate_under_65: 30.32,
      rate_between_65_and_81: 30.64,
      rate_from_82: 30.64,
      start_date: '2018-01-01',
      end_date: '2018-12-31'
    )
  end

  before(:each) do
    [person, home, placement, family_and_emergency_home_cost1,
     family_and_emergency_home_cost2, po_rate].each(&:reload)
  end

  it 'should have correct cost for a complete family_and_emergency_home_cost period' do
    costs = Economy::FamilyAndEmergencyHomeCost.new(
      person.placements,
      from: '2018-01-01',
      to: '2018-12-31'
    )
    expect(costs.sum.to_f.round(2)).to eq 613_149.07
  end

  it 'should use default report range' do
    costs = Economy::FamilyAndEmergencyHomeCost.new(person.placements, interval)
    expect(costs.sum).to be_a(Numeric)
  end

  it 'should have correct cost for a limiting full month report period' do
    costs = Economy::FamilyAndEmergencyHomeCost.new(
      person.placements,
      from: '2018-01-01',
      to: '2018-03-31'
    )
    expect(costs.sum.round(2)).to eq 118_632.01
  end

  it 'should have correct cost for a limiting partial month report period' do
    costs = Economy::FamilyAndEmergencyHomeCost.new(
      person.placements,
      from: '2018-01-01',
      to: '2018-01-10'
    )
    expect(costs.sum.round(2)).to eq 12_756.13
  end

  it 'should have correct cost for a limiting partial month report period exeeding placement time' do
    costs = Economy::FamilyAndEmergencyHomeCost.new(
      person.placements,
      from: '2017-01-01',
      to: '2019-01-10'
    )
    expect(costs.sum.to_f.round(2)).to eq 613_149.07
  end

  it 'should have correct cost formula' do
    costs = Economy::FamilyAndEmergencyHomeCost.new(
      person.placements,
      from: '2018-01-01',
      to: '2018-01-10'
    )
    expect(costs.as_formula).to eq '0.3225806452*(12345.0+3743.004+23456.0)'
  end
end
