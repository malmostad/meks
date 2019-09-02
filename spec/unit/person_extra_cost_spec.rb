RSpec.describe 'PersonExtraCost' do
  describe 'single cost' do
    let(:person) { create(:person) }

    let(:person_extra_cost) do
      create(
        :person_extra_cost,
        date: '2018-03-01',
        amount: 1234,
        person: person
      )
    end

    before(:each) do
      person.reload
      person_extra_cost.reload
    end

    it 'should have correct cost for a person_extra_cost period' do
      rec = Economy::PersonExtraCost.new(
        person,
        from: '2018-01-01',
        to: '2018-12-31'
      )
      expect(rec.sum).to eq 1234
    end

    it 'should have correct cost for a limiting full month report period' do
      rec = Economy::PersonExtraCost.new(
        person,
        from: '2018-01-01',
        to: '2018-03-31'
      )
      expect(rec.sum).to eq 1234
    end

    it 'should have a zero cost for a period without cost' do
      rec = Economy::PersonExtraCost.new(
        person,
        from: '2018-01-01',
        to: '2018-01-10'
      )
      expect(rec.sum).to eq 0
    end
  end

  describe 'multiple costs' do
    let(:person) { create(:person) }

    let(:person_extra_costs) do
      [
        create(
          :person_extra_cost,
          date: '2018-03-01',
          amount: 1234,
          person: person
        ),
        create(
          :person_extra_cost,
          date: '2018-03-10',
          amount: 2345,
          person: person
        )
      ]
    end

    before(:each) do
      person.reload
      person_extra_costs.each(&:reload)
    end

    it 'should have correct cost sum' do
      rec = Economy::PersonExtraCost.new(
        person,
        from: '2018-01-01',
        to: '2018-12-31'
      )
      expect(rec.sum).to eq 3579
    end

    it 'should have correct cost formula' do
      rec = Economy::PersonExtraCost.new(
        person,
        from: '2018-01-01',
        to: '2018-12-31'
      )
      expect(rec.as_formula).to eq '1234.0+2345.0'
    end
  end
end
