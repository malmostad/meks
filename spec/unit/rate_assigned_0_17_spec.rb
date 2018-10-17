# Schablonkategori Anvisad
# See specifications of conditions in app/lib/economy/rates.rb
RSpec.describe 'Rates for assigned_0_17' do
  before(:all) do
    create_rate_categories_with_rates
  end

  let(:refugee) { create(:refugee) }

  let(:municipality) do
    Municipality.where(id: Refugee::OUR_MUNICIPALITY_DEPARTMENT_ID).first_or_create { |m| m.name = 'Foo City' }
    Municipality.where(id: 1).first_or_create { |m| m.name = 'Bar Town' }
  end

  before(:each) do
    refugee.reload

    # Mandatories
    # refugee.municipality_placement_migrationsverket_at (defined below)
    refugee.municipality_id                            = Refugee::OUR_MUNICIPALITY_DEPARTMENT_ID

    # Count days from the last of the following
    refugee.date_of_birth                              = '2000-07-01'
    refugee.municipality_placement_migrationsverket_at = '2018-01-01'

    # Count days to the first of the following occurs
    # refugee.date_of_birth # + 1 year - 1 day (defined above)
    refugee.checked_out_to_our_city                    = '2018-07-01'
    refugee.deregistered                               = '2018-07-02' # - 1 day
  end

  it 'should have correct rate amount and days' do
    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

    expect(rate[:days]).to eq 91
  end

  it 'should respond to changed date_of_birth' do
    refugee.date_of_birth = '2018-04-06'

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

    expect(rate[:days]).to eq 86
  end

  it 'should respond to changed municipality_placement_migrationsverket_at' do
    refugee.municipality_placement_migrationsverket_at = '2018-04-06'

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

    expect(rate[:days]).to eq 86
  end

  it 'should respond to checked_out_to_our_city' do
    refugee.checked_out_to_our_city = '2018-04-06'

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

    expect(rate[:days]).to eq 6
  end

  it 'should respond to changed deregistered' do
    refugee.deregistered = '2018-06-01'

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

    expect(rate[:days]).to eq 61
  end

  it 'should require in_our_municipality_department' do
    refugee.municipality_id = 1

    rates = Economy::Rates.for_all_rate_categories(refugee, UnitMacros::REPORT_RANGE)
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

    expect(rate).to be_nil
  end
end
