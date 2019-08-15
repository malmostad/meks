# Schablonkategori Anvisad
# See specifications of conditions in app/lib/economy/rates.rb
RSpec.describe 'Rates for assigned_0_17' do
  let(:person) { create(:person_assigned_0_17) }

  before(:each) do
    create_rate_categories_with_rates
  end

  it 'should have correct rate amount and days' do
    rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

    expect(rate[:days]).to eq 91
  end

  it 'should respond to changed date_of_birth' do
    person.date_of_birth = '2018-04-06'

    rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

    expect(rate[:days]).to eq 86
  end

  it 'should respond to changed municipality_placement_migrationsverket_at' do
    person.municipality_placement_migrationsverket_at = '2018-04-06'

    rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

    expect(rate[:days]).to eq 86
  end

  it 'should respond to checked_out_to_our_city' do
    person.checked_out_to_our_city = '2018-04-06'

    rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

    expect(rate[:days]).to eq 6
  end

  it 'should respond to changed deregistered' do
    person.deregistered = '2018-06-01'

    rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

    expect(rate[:days]).to eq 61
  end

  it 'should require our_municipality' do
    person.municipality.update_attribute(:our_municipality, false)
    person.reload

    rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

    expect(rate).to be_nil
  end

  it 'should require EKB' do
    person.ekb = false

    rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

    expect(rate).to be_nil
  end

  describe 'deduction of days for placements with legal_code#exempt_from_rate' do
    it 'should have no rate for placement covering report range' do
      create(:placement_with_rate_exempt, person: person, moved_in_at: UnitMacros::REPORT_INTERVAL[:from])
      rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
      rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

      expect(rate).to eq nil
    end

    it 'should have a reduced number of days rate' do
      create(:placement_with_rate_exempt, person: person, moved_in_at: UnitMacros::REPORT_INTERVAL[:from].to_date + 1)
      rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
      rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

      expect(rate[:days]).to eq 1
    end

    it 'should not have rate exempt because fo citizenship' do
      person2 = create(:person, citizenship_at: Date.today - 5.years)
      create(:placement_with_rate_exempt, person: person2, moved_in_at: UnitMacros::REPORT_INTERVAL[:from].to_date + 1)
      rates = Economy::RatesForPerson.new(person2, UnitMacros::REPORT_INTERVAL).as_array
      rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

      expect(rate).to eq nil
    end

    it 'should have a reduced number of days rate' do
      create(
        :placement_with_rate_exempt,
        person: person,
        moved_in_at: UnitMacros::REPORT_INTERVAL[:from].to_date + 10,
        moved_out_at: UnitMacros::REPORT_INTERVAL[:to].to_date - 10
      )
      rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
      rate = detect_rate_by_amount(rates, UnitMacros::RATES[:assigned_0_17])

      expect(rate[:days]).to eq 20
    end
  end
end
