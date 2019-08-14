RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
    it 'assigns all users as @users' do
      user = User.create!(username: 'username', name: 'First Last', role: 'writer')
      get :index, params: {}, session: valid_session
      expect(assigns(:users)).to eq([user])
    end

    it 'raise an error if role is nil' do
      expect{User.create!(username: 'username', name: 'First Last', role: nil)}.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
