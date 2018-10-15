require 'rails_helper'

RSpec.describe 'ExtraContribution' do
  let(:refugee) { create(:refugee) }
  let(:extra_contribution) do
    create(
      :extra_contribution,
      period_start: '2018-01-01',
      period_end: '2018-12-31',
      fee: 12_345,
      expense: 23_456,
      refugee: refugee
    )
  end

  before do
    refugee.reload
    extra_contribution.reload
  end

  it 'should have correct cost for a complete extra_contribution period' do
    ec = Economy::ExtraContribution.new(
      refugee,
      from: '2018-01-01',
      to: '2018-12-31'
    )
    expect(ec.sum).to eq 429_612
  end

  it 'should use default report range' do
    ec = Economy::ExtraContribution.new(refugee)
    expect(ec.sum).to be_a(Numeric)
  end

  it 'should have correct cost for a limiting full month report period' do
    ec = Economy::ExtraContribution.new(
      refugee,
      from: '2018-01-01',
      to: '2018-03-31'
    )
    expect(ec.sum).to eq 107_403
  end

  it 'should have correct cost for a limiting partial month report period' do
    ec = Economy::ExtraContribution.new(
      refugee,
      from: '2018-01-01',
      to: '2018-01-10'
    )
    expect(ec.sum).to eq 11_548.71
  end

  it 'should have correct cost formula' do
    ec = Economy::ExtraContribution.new(
      refugee,
      from: '2018-01-01',
      to: '2018-01-10'
    )
    expect(ec.as_formula_array).to eq ['0.3225806451612903*35801.0']
  end

  describe 'multiple extra contributions' do
    let(:extra_contribution) do
      create(
        :extra_contribution,
        period_start: '2017-01-15',
        period_end: '2019-01-10',
        fee: 54_321,
        expense: 65_431,
        refugee: refugee
      )
    end

    it 'should have correct cost for a limiting partial month over several years report period' do
      ec = Economy::ExtraContribution.new(
        refugee,
        from: '2017-06-11',
        to: '2018-04-15'
      )
      expect(ec.sum).to eq 1_217_478.67
    end

    it 'should have correct cost formula' do
      ec = Economy::ExtraContribution.new(
        refugee,
        from: '2017-06-11',
        to: '2018-04-15'
      )
      expect(ec.as_formula_array).to eq ['10.166666666666666*119752.0']
    end
  end
end
