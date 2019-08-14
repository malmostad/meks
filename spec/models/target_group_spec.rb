RSpec.describe TargetGroup, type: :model do
  it 'should be adding one' do
    expect { create(:target_group) }.to change(TargetGroup, :count).by(+1)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(build(:target_group)).to be_valid
    end

    it 'should require a name' do
      expect(build(:target_group, name: nil)).not_to be_valid
    end

    it 'should be valid with a not too long name' do
      expect(build(:target_group, name: 'x' * 191)).to be_valid
    end

    it 'should not have a too long name' do
      expect(build(:target_group, name: 'x' * 192)).not_to be_valid
    end

    it 'should have a unique name' do
      create(:target_group, name: 'Yngre')
      expect(build(:target_group, name: 'Yngre')).not_to be_valid
    end

    it '... just checking transactional support' do
      expect(TargetGroup.count).to eq 0
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:target_group, name: 'Yngre') }.to change(TargetGroup, :count).by(+1)
      expect { TargetGroup.where(name: 'Yngre').first.destroy }.to change(TargetGroup, :count).by(-1)
    end

    it 'should delete a target_group reference for a home' do
      target_group = create(:target_group)
      home = create(:home, target_groups: [target_group])
      expect(home.target_groups).not_to be_empty
      target_group.destroy
      home.reload
      expect(home.target_groups).to be_empty
    end
  end
end
