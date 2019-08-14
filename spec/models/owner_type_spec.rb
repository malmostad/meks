RSpec.describe OwnerType, type: :model do
  it 'should be adding one' do
    expect { create(:owner_type) }.to change(OwnerType, :count).by(+1)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(build(:owner_type)).to be_valid
    end

    it 'should require a name' do
      expect(build(:owner_type, name: nil)).not_to be_valid
    end

    it 'should be valid with a not too long name' do
      expect(build(:owner_type, name: 'x' * 191)).to be_valid
    end

    it 'should not have a too long name' do
      expect(build(:owner_type, name: 'x' * 192)).not_to be_valid
    end

    it 'should have a unique name' do
      create(:owner_type, name: 'Egen')
      expect(build(:owner_type, name: 'Egen')).not_to be_valid
    end

    it '... just checking transactional support' do
      expect(OwnerType.count).to eq 0
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:owner_type, name: 'Egen') }.to change(OwnerType, :count).by(+1)
      expect { OwnerType.where(name: 'Egen').first.destroy }.to change(OwnerType, :count).by(-1)
    end

    it 'should delete a owner_type reference for a home' do
      owner_type = create(:owner_type)
      home = create(:home, owner_type: owner_type)
      expect(home.owner_type).to be_present
      owner_type.destroy
      home.reload
      expect(home.owner_type).not_to be_present
    end
  end
end
