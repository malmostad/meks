RSpec.describe 'RefugeeExtraCost' do
  describe 'single cost' do
    let(:refugee) { create(:refugee) }

    let(:refugee_extra_cost) do
      create(
        :refugee_extra_cost,
        date: '2018-03-01',
        amount: 1234,
        refugee: refugee
      )
    end

    before(:each) do
      refugee.reload
      refugee_extra_cost.reload
    end

    it 'should have correct cost for a refugee_extra_cost period' do
      rec = Economy::RefugeeExtraCost.new(
        refugee,
        from: '2018-01-01',
        to: '2018-12-31'
      )
      expect(rec.sum).to eq 1234
    end

    it 'should use default report range' do
      rec = Economy::RefugeeExtraCost.new(refugee)
      expect(rec.sum).to be_a(Numeric)
    end

    it 'should have correct cost for a limiting full month report period' do
      rec = Economy::RefugeeExtraCost.new(
        refugee,
        from: '2018-01-01',
        to: '2018-03-31'
      )
      expect(rec.sum).to eq 1234
    end

    it 'should have a zero cost for a period without cost' do
      rec = Economy::RefugeeExtraCost.new(
        refugee,
        from: '2018-01-01',
        to: '2018-01-10'
      )
      expect(rec.sum).to eq 0
    end
  end

  describe 'multiple costs' do
    let(:refugee) { create(:refugee) }

    let(:refugee_extra_costs) do
      [
        create(
          :refugee_extra_cost,
          date: '2018-03-01',
          amount: 1234,
          refugee: refugee
        ),
        create(
          :refugee_extra_cost,
          date: '2018-03-10',
          amount: 2345,
          refugee: refugee
        )
      ]
    end

    before(:each) do
      refugee.reload
      refugee_extra_costs.each(&:reload)
    end

    it 'should have correct cost sum' do
      rec = Economy::RefugeeExtraCost.new(
        refugee,
        from: '2018-01-01',
        to: '2018-12-31'
      )
      expect(rec.sum).to eq 3579
    end

    it 'should have correct cost formula' do
      rec = Economy::RefugeeExtraCost.new(
        refugee,
        from: '2018-01-01',
        to: '2018-12-31'
      )
      expect(rec.as_formula).to eq '1234.0+2345.0'
    end
  end
end
