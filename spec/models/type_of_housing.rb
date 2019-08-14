RSpec.describe TypeOfHousing, type: :model do
  it 'should be adding one' do
    expect { create(:type_of_housing) }.to change(TypeOfHousing, :count).by(+1)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(build(:type_of_housing)).to be_valid
    end

    it 'should require a name' do
      expect(build(:type_of_housing, name: nil)).not_to be_valid
    end

    it 'should be valid with a not too long name' do
      expect(build(:type_of_housing, name: 'x' * 191)).to be_valid
    end

    it 'should not have a too long name' do
      expect(build(:type_of_housing, name: 'x' * 192)).not_to be_valid
    end

    it 'should have a unique name' do
      create(:type_of_housing, name: 'Egen')
      expect(build(:type_of_housing, name: 'Egen')).not_to be_valid
    end

    it '... just checking transactional support' do
      expect(TypeOfHousing.count).to eq 0
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:type_of_housing, name: 'Egen') }.to change(TypeOfHousing, :count).by(+1)
      expect { TypeOfHousing.where(name: 'Egen').first.destroy }.to change(TypeOfHousing, :count).by(-1)
    end

    it 'should delete a type_of_housing reference for a home' do
      type_of_housing = create(:type_of_housing)
      home = create(:home, type_of_housing: type_of_housing)
      expect(home.type_of_housing).to be_present
      type_of_housing.destroy
      home.reload
      expect(home.type_of_housing).not_to be_present
    end
  end
end
