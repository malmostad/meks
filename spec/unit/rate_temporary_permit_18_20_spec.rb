# Förväntad intäkt för TUT 18-20
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
    rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:temporary_permit_18_20])

    expect(rate[:days]).to eq 91
  end

  it 'should respond to changed date_of_birth' do
    refugee.date_of_birth = '1997-04-06'

    rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:temporary_permit_18_20])

    expect(rate).to eq nil
  end

  it 'should respond to changed date_of_birth' do
    refugee.date_of_birth = '2000-06-20'

    rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:temporary_permit_18_20])

    expect(rate[:days]).to eq 11
  end

  it 'should respond to date_of_birth' do
    refugee.date_of_birth = '2001-01-01'

    rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:temporary_permit_18_20])

    expect(rate).to be_nil
  end

  describe 'deduction of days for placements with legal_code#exempt_from_rate' do
    it 'should have no rate for placement covering report range' do
      create(:placement_with_rate_exempt, refugee: refugee, moved_in_at: UnitMacros::REPORT_INTERVAL[:from])
      rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
      rate = detect_rate_by_amount(rates, UnitMacros::RATES[:temporary_permit_18_20])

      expect(rate).to eq nil
    end

    it 'should have a reduced number of days rate' do
      create(:placement_with_rate_exempt, refugee: refugee, moved_in_at: UnitMacros::REPORT_INTERVAL[:from].to_date + 1)
      rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
      rate = detect_rate_by_amount(rates, UnitMacros::RATES[:temporary_permit_18_20])

      expect(rate[:days]).to eq 1
    end

    it 'should not have rate_exempt because of citizenship' do
      refugee2 = create(:refugee, citizenship_at: Date.today - 5.years)
      create(:placement_with_rate_exempt, refugee: refugee2, moved_in_at: UnitMacros::REPORT_INTERVAL[:from].to_date + 1)
      rates = Economy::RatesForRefugee.new(refugee2, UnitMacros::REPORT_INTERVAL).as_array
      rate = detect_rate_by_amount(rates, UnitMacros::RATES[:temporary_permit_18_20])

      expect(rate).to eq nil
    end

    it 'should have a reduced number of days rate' do
      create(
        :placement_with_rate_exempt,
        refugee: refugee,
        moved_in_at: UnitMacros::REPORT_INTERVAL[:from].to_date + 10,
        moved_out_at: UnitMacros::REPORT_INTERVAL[:to].to_date - 10
      )
      rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
      rate = detect_rate_by_amount(rates, UnitMacros::RATES[:temporary_permit_18_20])

      expect(rate[:days]).to eq 20
    end
  end
end
