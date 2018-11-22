# Schablonkategori Anvisad
# See specifications of conditions in app/lib/economy/rates.rb
RSpec.describe 'Rates for assigned_0_17' do
  let(:municipality) { create(:municipality, our_municipality: true) }
  let(:refugee) { create(:refugee, municipality: municipality) }

  before(:each) do
    refugee.reload
    create_rate_categories_with_rates

    # Mandatories
    # refugee.municipality_placement_migrationsverket_at (defined below)
    # refugee.in_our_municipality (defined in let() above)

    # Count days from the last of the following
    refugee.date_of_birth                              = '2000-07-01'
    refugee.municipality_placement_migrationsverket_at = '2018-01-01'

    # Count days to the first of the following occurs
    # refugee.date_of_birth # + 1 year - 1 day (defined above)
    refugee.checked_out_to_our_city                    = '2018-07-01'
    refugee.deregistered                               = '2018-07-02' # - 1 day
  end

  it 'should have correct rate amount and days' do
    rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

    expect(rate[:days]).to eq 91
  end

  it 'should respond to changed date_of_birth' do
    refugee.date_of_birth = '2018-04-06'

    rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

    expect(rate[:days]).to eq 86
  end

  it 'should respond to changed municipality_placement_migrationsverket_at' do
    refugee.municipality_placement_migrationsverket_at = '2018-04-06'

    rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

    expect(rate[:days]).to eq 86
  end

  it 'should respond to checked_out_to_our_city' do
    refugee.checked_out_to_our_city = '2018-04-06'

    rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

    expect(rate[:days]).to eq 6
  end

  it 'should respond to changed deregistered' do
    refugee.deregistered = '2018-06-01'

    rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

    expect(rate[:days]).to eq 61
  end

  it 'should require in_our_municipality_department' do
    municipality.update_attribute(:our_municipality, false)
    refugee.reload

    rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

    expect(rate).to be_nil
  end

  describe 'deduction of days for placements with legal_code#exempt_from_rate' do
    it 'should have no rate for placement covering report range' do
      create(:placement_with_rate_exempt, refugee: refugee, moved_in_at: UnitMacros::REPORT_INTERVAL[:from])
      rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
      rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

      expect(rate).to eq nil
    end

    it 'should have a reduced number of days rate' do
      create(:placement_with_rate_exempt, refugee: refugee, moved_in_at: UnitMacros::REPORT_INTERVAL[:from].to_date + 1)
      rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
      rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

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
      rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

      expect(rate[:days]).to eq 20
    end
  end
end
