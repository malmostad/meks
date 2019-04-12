# Förväntad intäkt för TUT 0-17
RSpec.describe 'Rates' do
  let(:refugee) { create(:refugee) }

  before(:each) do
    refugee.reload
    create_rate_categories_with_rates
  end

  describe 'refugee with citizenship' do
    it 'should not belong to any rate category' do
      refugee.citizenship_at = '2017-01-01'
      rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array
      expect(rates.size).to eq 0
    end
  end

  describe 'deduction of days for placements with legal_code#exempt_from_rate' do
    it 'should have no rate for placement covering report range' do
      create(:placement_with_rate_exempt, refugee: refugee, moved_in_at: UnitMacros::REPORT_INTERVAL[:from])
      rates = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_array

      expect(rates.size).to eq 0
    end
  end
end
