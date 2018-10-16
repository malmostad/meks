require 'rails_helper'

# Förväntad schablon
RSpec.describe 'Rates' do
  RATES = {
    arrival_0_17: 1412,
    assigned_0_17: 1712,
    temporary_permit_0_17: 1987,
    temporary_permit_18_20: 1678,
    residence_permit_0_17: 1843,
    residence_permit_18_20: 1976
  }

  before(:all) do
    create_rate_categories_with_rates(RATES)
  end

  let(:municipality) do
    Municipality.where(id: Refugee::OUR_MUNICIPALITY_DEPARTMENT_ID).first_or_create { |m| m.name = 'Foo City' }
  end

  let(:refugee) do
    create(
      :refugee,
      date_of_birth: '2007-01-01',
      registered: '2016-01-01',
      deregistered: nil,
      residence_permit_at: nil,
      checked_out_to_our_city: '2017-05-10',
      temporary_permit_starts_at: '2017-01-01',
      temporary_permit_ends_at: '2018-06-01',
      municipality: municipality,
      municipality_placement_migrationsverket_at: '2016-01-01',
      municipality_placement_per_agreement_at: nil,
      citizenship_at: nil,
      sof_placement: false
    )
  end

  let(:report_range) { { from: '2018-04-01', to: '2018-06-30' } }

  before(:each) do
    refugee.reload
  end

  it 'should have correct rate amount and days for temporary_permit_0_17' do
    rates = Economy::Rates.for_all_rate_categories(refugee, report_range)
    expect(rates.size).to eq 1

    temporary_permit_0_17_rate = rates.detect { |rate| rate[:amount] == RATES[:temporary_permit_0_17] }
    expect(temporary_permit_0_17_rate[:days]).to eq 62
  end

  it 'should have correct rate amount and days for assigned_0_17' do
    refugee.checked_out_to_our_city = nil
    rates = Economy::Rates.for_all_rate_categories(refugee, report_range)
    expect(rates.size).to eq 1

    assigned_0_17_rate = rates.detect { |rate| rate[:amount] == RATES[:assigned_0_17] }
    expect(assigned_0_17_rate[:days]).to eq 91
  end

  it 'should not have any rate for the report range' do
    rate = Economy::Rates.for_all_rate_categories(refugee, from: '2020-04-01', to: '2020-06-30')
    expect(rate).to be_empty
  end
end
