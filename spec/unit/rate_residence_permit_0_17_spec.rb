# Förväntad intäkt för PUT 0-17
# See specifications of conditions in app/lib/economy/rates.rb
RSpec.describe 'Rates for residence_permit_0_17' do
  let(:municipality) do
    Municipality.where(our_municipality_department: true).first_or_create { |m| m.name = 'Foo City' }
  end

  let(:refugee) { create(:refugee) }

  before(:each) do
    refugee.reload
    create_rate_categories_with_rates
    # Mandatories
    # refugee.residence_permit_at (defined below)
    # refugee.before_checked_out_to_our_city (checked_out_to_our_city defined below)

    # Must not have
    # refugee.citizenship_at (defined below)

    # Count days from the last of the following
    refugee.date_of_birth           = '2010-01-01'
    refugee.residence_permit_at     = '2018-04-01' # + 1 day
    refugee.checked_out_to_our_city = '2018-01-01'

    # Count days to the first of the following
    # refugee.date_of_birth + 1 year - 1 day (defined above)
    refugee.citizenship_at          = nil
    refugee.deregistered            = nil # - 1 day
  end

  it 'should have correct number of days' do
    rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:residence_permit_0_17])

    expect(rate[:days]).to eq 91
  end

  it 'should respond to changed date_of_birth' do
    refugee.date_of_birth = '2018-04-06'

    rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:residence_permit_0_17])

    expect(rate[:days]).to eq 86
  end

  it 'should respond to changed residence_permit_at' do
    refugee.residence_permit_at = '2018-04-06'

    rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:residence_permit_0_17])

    expect(rate[:days]).to eq 86
  end

  it 'should respond to changed checked_out_to_our_city' do
    refugee.checked_out_to_our_city = '2018-04-06'

    rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:residence_permit_0_17])

    expect(rate[:days]).to eq 87
  end

  it 'should respond to changed deregistered' do
    refugee.deregistered = '2018-05-01'

    rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:residence_permit_0_17])

    expect(rate[:days]).to eq 30
  end

  it 'should require residence_permit_at' do
    refugee.residence_permit_at = nil

    rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:residence_permit_0_17])

    expect(rate).to be_nil
  end

  it 'should require checked_out_to_our_city' do
    refugee.checked_out_to_our_city = nil

    rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:residence_permit_0_17])

    expect(rate).to be_nil
  end

  it 'should no allow citizenship_at' do
    refugee.citizenship_at = '2018-05-01'
    rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:residence_permit_0_17])

    expect(rate).to be_nil
  end

  describe 'deduction of days for placements with legal_code#exempt_from_rate' do
    it 'should have no rate for placement covering report range' do
      create(:placement_with_rate_exempt, refugee: refugee, moved_in_at: UnitMacros::REPORT_INTERVAL[:from])
      rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
      rate = detect_rate_by_amount(rates, UnitMacros::RATES[:residence_permit_0_17])

      expect(rate).to eq nil
    end

    it 'should have a reduced number of days rate' do
      create(:placement_with_rate_exempt, refugee: refugee, moved_in_at: UnitMacros::REPORT_INTERVAL[:from].to_date + 1)
      rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
      rate = detect_rate_by_amount(rates, UnitMacros::RATES[:residence_permit_0_17])

      expect(rate[:days]).to eq 1
    end

    it 'should have a reduced number of days rate' do
      create(
        :placement_with_rate_exempt,
        refugee: refugee,
        moved_in_at: UnitMacros::REPORT_INTERVAL[:from].to_date + 10,
        moved_out_at: UnitMacros::REPORT_INTERVAL[:to].to_date - 10
      )
      rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
      rate = detect_rate_by_amount(rates, UnitMacros::RATES[:residence_permit_0_17])

      expect(rate[:days]).to eq 20
    end
  end
end
