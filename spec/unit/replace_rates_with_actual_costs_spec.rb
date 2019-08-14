RSpec.describe Economy::ReplaceRatesWithActualCosts do
  let(:refugee) { create(:refugee) }
  let(:home) { create(:home, type_of_cost: :cost_per_placement) }
  let(:placement) do
    create(
      :placement_with_rate_exempt,
      refugee: refugee,
      home: home,
      moved_in_at: '2018-03-15',
      moved_out_at: '2018-06-20',
      cost: 1234
    )
  end

  before(:each) do
    refugee.reload
    home.reload
    placement.reload

    create_rate_categories_with_rates
  end

  it 'should calulate cost' do
    expect(Economy::ReplaceRatesWithActualCosts.new(refugee).sum).to eq((97 + 1) * 1234)
  end

  it 'should calulate cost limited by report interval' do
    expect(Economy::ReplaceRatesWithActualCosts.new(
      refugee, from: '2018-02-01', to: '2018-03-31'
    ).sum).to eq((16 + 1) * 1234)
  end

  it 'should return an array of days and amount as a string' do
    expect(Economy::ReplaceRatesWithActualCosts.new(refugee).as_formula).to eq '98*1234'
  end

  it 'should return an array of days and amount' do
    expect(Economy::ReplaceRatesWithActualCosts.new(refugee).as_array).to eq([days: 98, amount: 1234])
  end

  it 'should not have rate_exempt because of citizenship' do
    refugee = create(:refugee, citizenship_at: Date.today - 5.years)
    expect(Economy::ReplaceRatesWithActualCosts.new(refugee).sum).to eq 0
  end

  it 'should not have rate_exempt because if EKB' do
    refugee.ekb = false
    expect(Economy::ReplaceRatesWithActualCosts.new(refugee).as_array).to be_empty
  end

  describe 'replacement with actual costs for rate categories' do
    let(:moved_in_at) { UnitMacros::REPORT_INTERVAL[:from].to_date }
    let(:moved_out_at) { UnitMacros::REPORT_INTERVAL[:to].to_date }
    let(:days) { (UnitMacros::REPORT_INTERVAL[:to].to_date - UnitMacros::REPORT_INTERVAL[:from].to_date + 1).to_i }
    let(:cost) do
      create(
        :cost,
        start_date: '2018-01-01',
        end_date: '2018-12-31',
        amount: 1234
      )
    end

    it 'should not be made for arrival_0_17 (exception from exempt' do
      refugee = create(:refugee_arrival_0_17)
      create(
        :placement_with_rate_exempt,
        home: cost.home,
        refugee: refugee,
        moved_in_at: moved_in_at,
        moved_out_at: moved_out_at
      )
      formula = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_formula

      expect(formula).to eq "#{days}*#{UnitMacros::RATES[:arrival_0_17]}"
    end

    it 'should be made for assigned_0_17' do
      refugee = create(:refugee_assigned_0_17)
      create(
        :placement_with_rate_exempt,
        refugee: refugee,
        home: cost.home,
        moved_in_at: moved_in_at,
        moved_out_at: moved_out_at
      )
      formula = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_formula

      expect(formula).to eq "#{days}*1234"
    end

    it 'should be made for temporary_permit_0_17' do
      refugee = create(:refugee_temporary_permit_0_17)
      create(
        :placement_with_rate_exempt,
        refugee: refugee,
        home: cost.home,
        moved_in_at: moved_in_at,
        moved_out_at: moved_out_at
      )
      formula = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_formula

      expect(formula).to eq "#{days}*1234"
    end

    it 'should be made for temporary_permit_18_20' do
      refugee = create(:refugee_temporary_permit_18_20)
      create(
        :placement_with_rate_exempt,
        refugee: refugee,
        home: cost.home,
        moved_in_at: moved_in_at,
        moved_out_at: moved_out_at
      )
      formula = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_formula

      expect(formula).to eq "#{days}*1234"
    end

    it 'should be made for residence_permit_0_17' do
      refugee = create(:refugee_residence_permit_0_17)
      create(
        :placement_with_rate_exempt,
        refugee: refugee,
        home: cost.home,
        moved_in_at: moved_in_at,
        moved_out_at: moved_out_at
      )
      formula = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_formula

      expect(formula).to eq "#{days}*1234"
    end

    it 'should be made for residence_permit_18_20' do
      refugee = create(:refugee_residence_permit_18_20)
      create(
        :placement_with_rate_exempt,
        refugee: refugee,
        home: cost.home,
        moved_in_at: moved_in_at,
        moved_out_at: moved_out_at
      )
      formula = Economy::RatesForRefugee.new(refugee, UnitMacros::REPORT_INTERVAL).as_formula

      expect(formula).to eq "#{days}*1234"
    end
  end
end
