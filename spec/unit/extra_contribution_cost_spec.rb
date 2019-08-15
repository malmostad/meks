RSpec.describe 'ExtraContributionCost' do
  let(:person) { create(:person) }
  let(:extra_contribution) do
    create(
      :extra_contribution,
      period_start: '2018-01-01',
      period_end: '2018-12-31',
      fee: 12_345,
      expense: 23_456,
      person: person
    )
  end
  let(:po_rate) do
    create(
      :po_rate,
      rate_under_65: 30.32,
      rate_between_65_and_81: 30.64,
      rate_from_82: 2.12,
      start_date: '2018-01-01',
      end_date: '2018-12-31'
    )
  end

  before(:each) do
    person.reload
    extra_contribution.reload
    po_rate.reload
  end

  it 'should have correct cost for a complete extra_contribution period' do
    ecc = Economy::ExtraContributionCost.new(
      person,
      from: '2018-01-01',
      to: '2018-12-31'
    )
    expect(ecc.sum.round(2)).to eq 474_528.05
  end

  it 'should use default report range' do
    ecc = Economy::ExtraContributionCost.new(person)
    expect(ecc.sum).to be_a(Numeric)
  end

  it 'should have correct cost for a limiting full month report period' do
    ecc = Economy::ExtraContributionCost.new(
      person,
      from: '2018-01-01',
      to: '2018-03-31'
    )
    expect(ecc.sum.round(2)).to eq 118_632.01
  end

  it 'should have correct cost for a limiting partial month report period' do
    ecc = Economy::ExtraContributionCost.new(
      person,
      from: '2018-01-01',
      to: '2018-01-10'
    )
    expect(ecc.sum.round(2)).to eq 12_756.13
  end

  it 'should have correct cost formula' do
    ecc = Economy::ExtraContributionCost.new(
      person,
      from: '2018-01-01',
      to: '2018-01-10'
    )
    expect(ecc.as_formula).to eq '0.3225806451612903*(12345.0+3743.004+23456.0)'
  end

  describe 'extra contributions of outpatient type' do
    let(:outpatient_type) do
      create(:extra_contribution_type, outpatient: true)
    end

    let(:extra_contribution) do
      create(
        :extra_contribution,
        period_start: '2019-01-01',
        period_end: '2019-06-30',
        monthly_cost: 54_321,
        person: person,
        extra_contribution_type: outpatient_type
      )
    end

    let(:ecc) do
      Economy::ExtraContributionCost.new(
        person,
        from: '2018-07-01',
        to: '2019-06-30'
      )
    end

    before(:each) do
      extra_contribution.reload
    end

    it 'should have correct monthly cost for a limiting partial month over several years report period' do
      expect(ecc.sum).to eq 325_926
    end

    it 'should have correct cost formula' do
      expect(ecc.as_formula).to eq '6.0*54321.0'
    end
  end
end
