# Förväntad intäkt för PUT 18-20
# See specifications of conditions in app/lib/economy/rates.rb
#
# The majority of test for this rate category is performed
# in rate_residence_permit_0_17_spec.rb. Only conditionals for date of birth differs
RSpec.describe 'Rates for residence_permit_18_20' do
  let(:municipality) do
    Municipality.where(our_municipality: true).first_or_create { |m| m.name = 'Foo City' }
  end

  let(:person) { create(:person_residence_permit_18_20) }

  before(:each) do
    create_rate_categories_with_rates
  end

  it 'should have correct rate amount and days' do
    rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:residence_permit_18_20])

    expect(rate[:days]).to eq 91
  end

  it 'should respond to changed date_of_birth' do
    person.date_of_birth = '1997-04-06'

    rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:residence_permit_18_20])

    expect(rate).to eq nil
  end

  it 'should respond to changed date_of_birth' do
    person.date_of_birth = '2000-06-20'

    rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:residence_permit_18_20])

    expect(rate[:days]).to eq 11
  end

  it 'should respond to date_of_birth' do
    person.date_of_birth = '2001-01-01'

    rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
    rate = detect_rate_by_amount(rates, UnitMacros::RATES[:residence_permit_18_20])

    expect(rate).to be_nil
  end

  it 'should respond to changed EKB' do
    person.ekb = false
    rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array

    expect(rates).to be_empty
  end

  describe 'deduction of days for placements with legal_code#exempt_from_rate' do
    it 'should have no rate for placement covering report range' do
      create(:placement_with_rate_exempt, person: person, moved_in_at: UnitMacros::REPORT_INTERVAL[:from])
      rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
      rate = detect_rate_by_amount(rates, UnitMacros::RATES[:residence_permit_18_20])

      expect(rate).to eq nil
    end

    it 'should have a reduced number of days rate' do
      create(:placement_with_rate_exempt, person: person, moved_in_at: UnitMacros::REPORT_INTERVAL[:from].to_date + 1)
      rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
      rate = detect_rate_by_amount(rates, UnitMacros::RATES[:residence_permit_18_20])

      expect(rate[:days]).to eq 1
    end

    it 'should have a reduced number of days rate' do
      create(
        :placement_with_rate_exempt,
        person: person,
        moved_in_at: UnitMacros::REPORT_INTERVAL[:from].to_date + 10,
        moved_out_at: UnitMacros::REPORT_INTERVAL[:to].to_date - 10
      )
      rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
      rate = detect_rate_by_amount(rates, UnitMacros::RATES[:residence_permit_18_20])

      expect(rate[:days]).to eq 20
    end
  end
end
