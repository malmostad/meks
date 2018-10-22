# Förväntad schablon för TUT 18-20
#
# See specifications of conditions in app/lib/economy/rates.rb
#
# The majority of test for this rate category is performed
# in rate_temporary_permit_0_17_spec.rb. Only conditionals for date of birth differs
RSpec.describe 'Rates for temporary_permit_18_20' do
  let(:refugee) { create(:refugee) }

  before(:each) do
    refugee.reload
    create_rate_categories_with_rates
    # Mandatories
    # refugee.temporary_permit_starts_at (defined below)
    # refugee.temporary_permit_ends_at (defined below)
    # refugee.checked_out_to_our_city (defined below)

    # Count days from the last of the following
    refugee.date_of_birth              = '1999-07-01'
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
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:temporary_permit_18_20])

    expect(rate[:days]).to eq 91
  end

  it 'should respond to changed date_of_birth' do
    refugee.date_of_birth = '1997-04-06'

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:temporary_permit_18_20])

    expect(rate[:days]).to eq 5
  end

  it 'should respond to changed date_of_birth' do
    refugee.date_of_birth = '2000-06-20'

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:temporary_permit_18_20])

    expect(rate[:days]).to eq 11
  end

  it 'should respond to date_of_birth' do
    refugee.date_of_birth = '2001-01-01'

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:temporary_permit_18_20])

    expect(rate).to be_nil
  end
end
