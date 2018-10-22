# Förväntad intäkt för TUT 0-17
# See specifications of conditions in app/lib/economy/rates.rb
RSpec.describe 'Rates for temporary_permit_0_17' do
  let(:municipality) do
    Municipality.where(id: Refugee::OUR_MUNICIPALITY_DEPARTMENT_ID).first_or_create { |m| m.name = 'Foo City' }
  end

  let(:refugee) { create(:refugee) }

  before(:each) do
    refugee.reload
    create_rate_categories_with_rates
    # Mandatories
    # refugee.temporary_permit_starts_at (defined below)
    # refugee.temporary_permit_ends_at (defined below)
    # refugee.checked_out_to_our_city (defined below)

    # Count days from the last of the following
    refugee.date_of_birth              = '2010-01-01'
    refugee.checked_out_to_our_city    = '2018-04-01' # + 1 day
    refugee.temporary_permit_starts_at = '2018-01-01'

    # Count days to the first of the following
    # refugee.date_of_birth + 1 year - 1 day (defined above)
    refugee.temporary_permit_ends_at   = '2020-01-01'
    refugee.residence_permit_at        = nil
    refugee.deregistered               = nil # - 1 day
  end

  it 'should have correct rate amount and days' do
    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:temporary_permit_0_17])

    expect(rate[:days]).to eq 91
  end

  it 'should respond to changed checked_out_to_our_city' do
    refugee.checked_out_to_our_city = '2018-04-06'

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:temporary_permit_0_17])

    expect(rate[:days]).to eq 87
  end

  it 'should respond to changed date_of_birth' do
    refugee.date_of_birth = '2018-04-06'

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:temporary_permit_0_17])

    expect(rate[:days]).to eq 86
  end

  it 'should respond to changed temporary_permit_starts_at' do
    refugee.temporary_permit_starts_at = '2018-04-06'

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:temporary_permit_0_17])

    expect(rate[:days]).to eq 86
  end

  it 'should respond to changed residence_permit_at' do
    refugee.residence_permit_at = '2018-06-01'

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:temporary_permit_0_17])

    expect(rate[:days]).to eq 62
  end

  it 'should respond to changed deregistered' do
    refugee.deregistered = '2018-05-01'

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:temporary_permit_0_17])

    expect(rate[:days]).to eq 30
  end

  it 'should respond to changed deregistered' do
    refugee.temporary_permit_ends_at = '2018-05-01'

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:temporary_permit_0_17])

    expect(rate[:days]).to eq 31
  end

  it 'should respond to date_of_birth' do
    refugee.date_of_birth = '2000-01-01'

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:temporary_permit_0_17])

    expect(rate).to be_nil
  end

  it 'should require temporary_permit_starts_at' do
    refugee.temporary_permit_starts_at = nil

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:temporary_permit_0_17])

    expect(rate).to be_nil
  end

  it 'should require temporary_permit_ends_at' do
    refugee.temporary_permit_ends_at = nil

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:temporary_permit_0_17])

    expect(rate).to be_nil
  end

  it 'should require checked_out_to_our_city' do
    refugee.checked_out_to_our_city = nil
    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:temporary_permit_0_17])

    expect(rate).to be_nil
  end
end
