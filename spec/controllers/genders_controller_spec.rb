RSpec.describe GendersController, type: :controller do
  let(:valid_attributes) {
    { name: 'Flicka' }
  }

  let(:invalid_attributes) {
    { name: nil }
  }

  describe 'GET #index' do
    it 'assigns all genders as @genders' do
      gender = Gender.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:genders)).to eq([gender])
    end
  end

  describe 'GET #new' do
    it 'assigns a new gender as @gender' do
      get :new, params: {}, session: valid_session
      expect(assigns(:gender)).to be_a_new(Gender)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested gender as @gender' do
      gender = Gender.create! valid_attributes
      get :edit, params: { id: gender.to_param }, session: valid_session
      expect(assigns(:gender)).to eq(gender)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Gender' do
        expect {
          post :create, params: { gender: valid_attributes }, session: valid_session
        }.to change(Gender, :count).by(1)
      end

      it 'assigns a newly created gender as @gender' do
        post :create, params: { gender: valid_attributes }, session: valid_session
        expect(assigns(:gender)).to be_a(Gender)
        expect(assigns(:gender)).to be_persisted
      end

      it 'redirects to the created gender' do
        post :create, params: { gender: valid_attributes }, session: valid_session
        expect(response).to redirect_to(genders_url)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved gender as @gender' do
        post :create, params: { gender: invalid_attributes }, session: valid_session
        expect(assigns(:gender)).to be_a_new(Gender)
      end

      it "re-renders the 'new' template" do
        post :create, params: { gender: invalid_attributes }, session: valid_session
        expect(response).to render_template('new')
      end

      it 'too long name' do
        post :create, params: { gender: { name: 'x' * 200 } }, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'updates the requested gender' do
        gender = Gender.create! valid_attributes
        new_name = "#{gender.name} updated"
        put :update, params: { id: gender.to_param, gender: { name: new_name } }, session: valid_session
        gender.reload
        expect(gender.name).to eq(new_name)
      end

      it 'assigns the requested gender as @gender' do
        gender = Gender.create! valid_attributes
        put :update, params: { id: gender.to_param, gender: valid_attributes}, session: valid_session
        expect(assigns(:gender)).to eq(gender)
      end

      it 'redirects to the gender' do
        gender = Gender.create! valid_attributes
        put :update, params: { id: gender.to_param, gender: valid_attributes}, session: valid_session
        expect(response).to redirect_to(genders_url)
      end
    end

    context 'with invalid params' do
      it 'assigns the gender as @gender' do
        gender = Gender.create! valid_attributes
        put :update, params: { id: gender.to_param, gender: invalid_attributes}, session: valid_session
        expect(assigns(:gender)).to eq(gender)
      end

      it "re-renders the 'edit' template" do
        gender = Gender.create! valid_attributes
        put :update, params: { id: gender.to_param, gender: invalid_attributes}, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested gender' do
      gender = Gender.create! valid_attributes
      expect {
        delete :destroy, params: { id: gender.to_param }, session: valid_session
      }.to change(Gender, :count).by(-1)
    end

    it 'redirects to the genders list' do
      gender = Gender.create! valid_attributes
      delete :destroy, params: { id: gender.to_param }, session: valid_session
      expect(response).to redirect_to(genders_url)
    end
  end
end
