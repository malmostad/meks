RSpec.describe TypeOfRelationship, type: :model do
  it 'should be adding one' do
    expect { create(:type_of_relationship) }.to change(TypeOfRelationship, :count).by(+1)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(build(:type_of_relationship)).to be_valid
    end

    it 'should require a name' do
      expect(build(:type_of_relationship, name: nil)).not_to be_valid
    end

    it 'should be valid with a not too long name' do
      expect(build(:type_of_relationship, name: 'x' * 191)).to be_valid
    end

    it 'should not have a too long name' do
      expect(build(:type_of_relationship, name: 'x' * 192)).not_to be_valid
    end

    it 'should have a unique name' do
      create(:type_of_relationship, name: 'syster')
      expect(build(:type_of_relationship, name: 'syster')).not_to be_valid
    end

    it '... just checking transactional support' do
      expect(TypeOfRelationship.count).to eq 0
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:type_of_relationship, name: 'syster') }.to change(TypeOfRelationship, :count).by(+1)
      expect { TypeOfRelationship.where(name: 'Syster').first.destroy }.to change(TypeOfRelationship, :count).by(-1)
    end

    it 'should delete a type_of_relationship reference for a relationship' do
      type_of_relationship = create(:type_of_relationship)
      relationship = create(:relationship, type_of_relationship: type_of_relationship)
      expect(relationship.type_of_relationship).to be_present
      type_of_relationship.destroy
      relationship.reload
      expect(relationship.type_of_relationship).not_to be_present
    end
  end
end
