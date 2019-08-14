RSpec.describe DeregisteredReason, type: :model do
  it 'should be adding one' do
    expect { create(:deregistered_reason) }.to change(DeregisteredReason, :count).by(+1)
  end

  describe 'validation' do
    it 'should be valid' do
      expect( build(:deregistered_reason) ).to be_valid
    end

    it 'should require a name' do
      expect(build(:deregistered_reason, name: nil)).not_to be_valid
    end

    it 'should be valid with a not too long name' do
      expect(build(:deregistered_reason, name: 'x' * 191)).to be_valid
    end

    it 'should not have a too long name' do
      expect(build(:deregistered_reason, name: 'x' * 192)).not_to be_valid
    end

    it 'should have a unique name' do
      create(:deregistered_reason, name: '18 år')
      expect(build(:deregistered_reason, name: '18 år')).not_to be_valid
    end

    it '... just checking transactional support' do
      expect(DeregisteredReason.count).to eq 0
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:deregistered_reason, name: '18 år') }.to change(DeregisteredReason, :count).by(+1)
      expect { DeregisteredReason.where(name: '18 år').first.destroy }.to change(DeregisteredReason, :count).by(-1)
    end
  end
end
