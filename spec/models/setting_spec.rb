RSpec.describe Setting, type: :model do
  it 'should be adding one' do
    expect { create(:setting) }.to change(Setting, :count).by(+1)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(build(:setting)).to be_valid
    end

    it 'should require a key' do
      expect(build(:setting, key: nil)).not_to be_valid
    end

    it 'should require a human_name' do
      expect(build(:setting, human_name: nil)).not_to be_valid
    end

    it 'should require a value' do
      expect(build(:setting, value: nil)).not_to be_valid
    end

    it 'should be valid with a not too long name' do
      expect(build(:setting, value: 'x' * 191)).to be_valid
    end

    it 'should not have a too long name' do
      expect(build(:setting, value: 'x' * 192)).not_to be_valid
    end

    it 'should have a unique key' do
      create(:setting, key: 'setting_1')
      expect(build(:setting, key: 'setting_1')).not_to be_valid
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:setting) }.to change(Setting, :count).by(+1)
      expect { Setting.first.destroy }.to change(Setting, :count).by(-1)
    end
  end
end
