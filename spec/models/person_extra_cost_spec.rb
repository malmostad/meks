RSpec.describe PersonExtraCost, type: :model do
  it 'should be adding one' do
    expect { create(:person_extra_cost) }.to change(PersonExtraCost, :count).by(+1)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(build(:person_extra_cost)).to be_valid
    end

    it 'should require a date' do
      expect(build(:person_extra_cost, date: nil)).not_to be_valid
    end

    it 'should require amount to be numericality' do
      expect(build(:person_extra_cost, amount: 'foo')).not_to be_valid
    end

    it 'should limit comment to be 191 chars' do
      expect(build(:person_extra_cost, comment: 'x' * 200)).not_to be_valid
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:person_extra_cost) }.to change(PersonExtraCost, :count).by(+1)
      expect { PersonExtraCost.first.destroy }.to change(PersonExtraCost, :count).by(-1)
    end

    it 'should delete a person_extra_cost reference for a person' do
      person = create(:person)
      person_extra_cost = create(:person_extra_cost, person: person)
      expect(person_extra_cost.person).not_to be_blank
      person.destroy
      expect(PersonExtraCost.where(id: person_extra_cost.id)).to be_blank
    end

    it 'should not delete a person when deleted' do
      person = create(:person)
      person_extra_cost = create(:person_extra_cost, person: person)
      expect(person_extra_cost).not_to be_blank
      person_extra_cost.destroy
      person.reload
      expect(person).not_to be_blank
    end
  end
end
