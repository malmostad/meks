RSpec.describe User, type: :model do
  it 'should be adding one' do
    expect { create(:user) }.to change(User, :count).by(+1)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(build(:user)).to be_valid
    end

    it 'should require a username' do
      expect(build(:user, username: nil)).not_to be_valid
    end

    it 'should require a role' do
      expect(build(:user, role: nil)).not_to be_valid
    end

    it 'should be valid with a not too long username' do
      expect(build(:user, username: 'x' * 191)).to be_valid
    end

    it 'should not have a too long username' do
      expect(build(:user, username: 'x' * 192)).not_to be_valid
    end

    it 'should not have a too long name' do
      expect(build(:user, name: 'x' * 191)).to be_valid
    end

    it 'should not have a too long email' do
      expect(build(:user, name: 'x' * 192)).not_to be_valid
    end

    it 'should have a unique username' do
      create(:user, username: 'firlas')
      expect(build(:user, username: 'firlas')).not_to be_valid
    end

    it '... just checking transactional support' do
      expect(User.count).to eq 0
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:user, username: 'firlas') }.to change(User, :count).by(+1)
      expect { User.where(username: 'firlas').first.destroy }.to change(User, :count).by(-1)
    end
  end

  describe 'methods' do
    it 'should get the role right' do
      user = create(:user, role: 'writer')
      expect(user.has_role? :writer).to be(true)
    end

    it 'should get the false role right' do
      user = create(:user, role: 'writer')
      expect(user.has_role? :admin).not_to be(true)
    end
  end
end
