RSpec.describe Country, type: :model do
  it 'should be adding one' do
    expect { create(:country) }.to change(Country, :count).by(+1)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(build(:country)).to be_valid
    end

    it 'should require a name' do
      expect(build(:country, name: nil)).not_to be_valid
    end

    it 'should be valid with a not too long name' do
      expect(build(:country, name: 'x' * 191)).to be_valid
    end

    it 'should not have a too long name' do
      expect(build(:country, name: 'x' * 192)).not_to be_valid
    end

    it 'should have a unique name' do
      create(:country, name: 'Sverige')
      expect(build(:country, name: 'Sverige')).not_to be_valid
    end

    it '... just checking transactional support' do
      expect(Country.count).to eq 0
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:country, name: 'Sverige') }.to change(Country, :count).by(+1)
      expect { Country.where(name: 'Sverige').first.destroy }.to change(Country, :count).by(-1)
    end

    it 'should delete a country reference for a person' do
      country = create(:country)
      person = create(:person, countries: [country])
      expect(person.countries).to be_present
      country.destroy
      person.reload
      expect(person.countries).to be_empty
    end
  end
end
