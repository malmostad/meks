RSpec.describe LegalCode, type: :model do
  it 'should be adding one' do
    expect { create(:legal_code) }.to change(LegalCode, :count).by(+1)
  end

  describe 'validation' do
    it 'should be valid' do
      expect( build(:legal_code) ).to be_valid
    end

    it 'should require a name' do
      expect(build(:legal_code, name: nil)).not_to be_valid
    end

    it 'should be valid with a not too long name' do
      expect(build(:legal_code, name: 'x' * 191)).to be_valid
    end

    it 'should not have a too long name' do
      expect(build(:legal_code, name: 'x' * 192)).not_to be_valid
    end

    it 'should have a unique name' do
      create(:legal_code, name: '18 år')
      expect(build(:legal_code, name: '18 år')).not_to be_valid
    end

    it '... just checking transactional support' do
      expect(LegalCode.count).to eq 0
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:legal_code, name: '18 år') }.to change(LegalCode, :count).by(+1)
      expect { LegalCode.where(name: '18 år').first.destroy }.to change(LegalCode, :count).by(-1)
    end
  end
end
