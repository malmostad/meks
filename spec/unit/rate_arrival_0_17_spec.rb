# Schablonkategori Ankomstbarn 0-17
# See specifications of conditions in app/lib/economy/rates.rb
RSpec.describe 'Rates for arrival_0_17' do
  let(:refugee) { create(:refugee) }

  before(:each) do
    refugee.reload
    create_rate_categories_with_rates

    # Mandatories
    # refugee.registered (defined below)

    # Must not have
    # refugee.citizenship_at (defined below)

    # Count days from the last of the following
    refugee.date_of_birth                              = '2010-01-01'
    refugee.registered                                 = '2018-01-01'

    # Count days to the first of the following occurs
    # refugee.date_of_birth # + 1 year - 1 day (defined above)
    refugee.deregistered                               = nil
    refugee.municipality_placement_migrationsverket_at = '2019-01-01'
    refugee.temporary_permit_starts_at                 = '2019-01-01'
    refugee.residence_permit_at                        = nil
    refugee.citizenship_at                             = nil
  end

  it 'should have correct rate amount and days' do
    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

    expect(rate[:days]).to eq 91
  end

  it 'should respond to changed registered' do
    refugee.registered = '2018-04-06'

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

    expect(rate[:days]).to eq 86
  end

  it 'should respond to changed date_of_birth' do
    refugee.date_of_birth = '2018-04-06'

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

    expect(rate[:days]).to eq 86
  end

  it 'should respond to changed deregistered' do
    refugee.deregistered = '2018-04-06'

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

    expect(rate[:days]).to eq 5
  end

  it 'should respond to changed municipality_placement_migrationsverket_at' do
    refugee.residence_permit_at = '2018-06-01'

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

    expect(rate[:days]).to eq 62
  end

  it 'should respond to temporary_permit_starts_at' do
    refugee.temporary_permit_starts_at = '2018-05-01'

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

    expect(rate[:days]).to eq 31
  end

  it 'should respond to residence_permit_at' do
    refugee.residence_permit_at = '2018-05-01'

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

    expect(rate[:days]).to eq 31
  end

  it 'should respond to citizenship_at' do
    refugee.citizenship_at = '2018-01-01'

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

    expect(rate).to be_nil
  end

  it 'should require registered' do
    refugee.registered = nil

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

    expect(rate).to be_nil
  end

  it 'should not have refugee.citizenship_at' do
    refugee.citizenship_at = '2018-01-01'

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

    expect(rate).to be_nil
  end
end
