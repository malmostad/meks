# Förväntad intäkt för TUT 0-17
RSpec.describe 'Rates' do
  let(:person) { create(:person) }

  before(:each) do
    person.reload
    create_rate_categories_with_rates
  end

  describe 'person with citizenship' do
    it 'should not belong to any rate category' do
      person.citizenship_at = '2017-01-01'
      rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
      expect(rates.size).to eq 0
    end
  end

  describe 'person with EKB' do
    it 'should not belong to any rate category' do
      person.ekb = false
      rates = Economy::RatesForPerson.new(person, UnitMacros::REPORT_INTERVAL).as_array
      expect(rates.size).to eq 0
    end
  end
end
