# Schablonkategori Ankomstbarn 0-17
# See specifications of conditions in app/lib/economy/rates.rb
RSpec.describe 'Rates for arrival_0_17' do
  let(:person) { create(:person_arrival_0_17) }

  before(:each) do
    create_rate_categories_with_rates
  end

  it 'should have correct rate amount and days' do
    rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

    expect(rate[:days]).to eq 91
  end

  it 'should respond to changed registered' do
    person.registered = '2018-04-06'

    rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

    expect(rate[:days]).to eq 86
  end

  it 'should respond to changed date_of_birth' do
    person.date_of_birth = '2018-04-06'

    rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

    expect(rate[:days]).to eq 86
  end

  it 'should respond to changed deregistered' do
    person.deregistered = '2018-04-06'

    rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

    expect(rate[:days]).to eq 5
  end

  it 'should respond to changed municipality_placement_migrationsverket_at' do
    person.residence_permit_at = '2018-06-01'

    rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

    expect(rate[:days]).to eq 62
  end

  it 'should respond to temporary_permit_starts_at' do
    person.temporary_permit_starts_at = '2018-05-01'

    rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

    expect(rate[:days]).to eq 31
  end

  it 'should respond to residence_permit_at' do
    person.residence_permit_at = '2018-05-01'

    rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

    expect(rate[:days]).to eq 31
  end

  it 'should respond to citizenship_at' do
    person.citizenship_at = '2018-01-01'

    rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

    expect(rate).to be_nil
  end

  it 'should require registered' do
    person.registered = nil

    rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

    expect(rate).to be_nil
  end

  it 'should not have person.citizenship_at' do
    person.citizenship_at = '2018-01-01'

    rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

    expect(rate).to be_nil
  end

  it 'should not have rate if EKB' do
    person.ekb = false

    rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
    expect(rates).to be_empty
  end

  describe 'deduction of days for placements with legal_code#exempt_from_rate should not be made for arrival_0_17' do
    it 'should not have rate for placement covering report range' do
      create(:placement_with_rate_exempt, person: person, moved_in_at: UnitMacros::REPORT_INTERVAL[:from])
      rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
      rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

      expect(rate[:days]).to eq 91
    end

    it 'should not have a reduced number of days rate' do
      create(:placement_with_rate_exempt, person: person, moved_in_at: UnitMacros::REPORT_INTERVAL[:from].to_date + 1)
      rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
      rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

      expect(rate[:days]).to eq 91
    end

    it 'should not have a reduced number of days rate' do
      create(
        :placement_with_rate_exempt,
        person: person,
        moved_in_at: UnitMacros::REPORT_INTERVAL[:from].to_date + 10,
        moved_out_at: UnitMacros::REPORT_INTERVAL[:to].to_date - 10
      )
      rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
      rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

      expect(rate[:days]).to eq 91
    end

    it 'should not have a reduced number of days rate' do
      create(
        :placement_with_rate_exempt,
        person: person,
        moved_in_at: UnitMacros::REPORT_INTERVAL[:from].to_date + 10,
        moved_out_at: UnitMacros::REPORT_INTERVAL[:to].to_date + 10
      )
      rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
      rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

      expect(rate[:days]).to eq 91
    end

    it 'should not have a reduced number of days rate' do
      create(
        :placement_with_rate_exempt,
        person: person,
        moved_in_at: UnitMacros::REPORT_INTERVAL[:to].to_date + 1,
        moved_out_at: UnitMacros::REPORT_INTERVAL[:to].to_date + 10
      )
      rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
      rate = detect_rate_by_amount(rates, UnitMacros::RATES[:arrival_0_17])

      expect(rate[:days]).to eq 91
    end
  end
end
