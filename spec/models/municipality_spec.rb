RSpec.describe Municipality, type: :model do
  it 'should be adding one' do
    expect { create(:municipality) }.to change(Municipality, :count).by(+1)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(build(:municipality)).to be_valid
    end

    it 'should require a name' do
      expect(build(:municipality, name: nil)).not_to be_valid
    end

    it 'should be valid with a not too long name' do
      expect(build(:municipality, name: 'x' * 191)).to be_valid
    end

    it 'should not have a too long name' do
      expect(build(:municipality, name: 'x' * 192)).not_to be_valid
    end

    it 'should have a unique name' do
      create(:municipality, name: 'Umeå')
      expect(build(:municipality, name: 'Umeå')).not_to be_valid
    end

    it '... just checking transactional support' do
      expect(Municipality.count).to eq 0
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:municipality, name: 'Umeå') }.to change(Municipality, :count).by(+1)
      expect { Municipality.where(name: 'Umeå').first.destroy }.to change(Municipality, :count).by(-1)
    end

    it 'should delete a municipality reference for a person' do
      municipality = create(:municipality)
      person = create(:person, municipality: municipality)
      expect(person.municipality).to be_present
      municipality.destroy
      person.reload
      expect(person.municipality).not_to be_present
    end
  end
end
