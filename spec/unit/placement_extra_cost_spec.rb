RSpec.describe 'PlacementExtraCost' do
  let(:interval) { { from: Date.new(0), to: Date.today } }

  describe 'single cost' do
    let(:person) { create(:person) }
    let(:placement) { create(:placement, person: person) }

    let(:placement_extra_cost) do
      create(
        :placement_extra_cost,
        date: '2018-03-01',
        amount: 1234,
        placement: placement
      )
    end

    before(:each) do
      person.reload
      placement.reload
      placement_extra_cost.reload
    end

    it 'should have correct cost for a placement_extra_cost period' do
      rec = Economy::PlacementExtraCost.new(
        person.placements,
        from: '2018-01-01',
        to: '2018-12-31'
      )
      expect(rec.sum).to eq 1234
    end

    it 'should use default report range' do
      rec = Economy::PlacementExtraCost.new(person.placements, interval)
      expect(rec.sum).to be_a(Numeric)
    end

    it 'should have correct cost for a limiting full month report period' do
      rec = Economy::PlacementExtraCost.new(
        person.placements,
        from: '2018-01-01',
        to: '2018-03-31'
      )
      expect(rec.sum).to eq 1234
    end

    it 'should have a zero cost for a period without cost' do
      rec = Economy::PlacementExtraCost.new(
        person.placements,
        from: '2018-01-01',
        to: '2018-01-10'
      )
      expect(rec.sum).to eq 0
    end
  end

  describe 'multiple costs' do
    let(:person) { create(:person) }
    let(:placement) { create(:placement, person: person) }

    let(:placement_extra_costs) do
      [
        create(
          :placement_extra_cost,
          date: '2018-03-01',
          amount: 1234,
          placement: placement
        ),
        create(
          :placement_extra_cost,
          date: '2018-03-10',
          amount: 2345,
          placement: placement
        )
      ]
    end

    before(:each) do
      person.reload
      placement.reload
      placement_extra_costs.each(&:reload)
    end

    it 'should have correct cost sum' do
      rec = Economy::PlacementExtraCost.new(
        person.placements,
        from: '2018-01-01',
        to: '2018-12-31'
      )
      expect(rec.sum).to eq 3579
    end

    it 'should have correct cost formula' do
      rec = Economy::PlacementExtraCost.new(
        person.placements,
        from: '2018-01-01',
        to: '2018-12-31'
      )
      expect(rec.as_formula).to eq '1234.0+2345.0'
    end
  end
end
