RSpec.describe MunicipalitiesController, type: :controller do
  let(:valid_attributes) {
    { name: 'Svenska' }
  }

  let(:invalid_attributes) {
    { name: nil }
  }

  describe 'GET #index' do
    it 'assigns all municipalities as @municipalities' do
      municipality = Municipality.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:municipalities)).to eq([municipality])
    end
  end

  describe 'GET #new' do
    it 'assigns a new municipality as @municipality' do
      get :new, params: {}, session: valid_session
      expect(assigns(:municipality)).to be_a_new(Municipality)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested municipality as @municipality' do
      municipality = Municipality.create! valid_attributes
      get :edit, params: { id: municipality.to_param }, session: valid_session
      expect(assigns(:municipality)).to eq(municipality)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Municipality' do
        expect {
          post :create, params: { municipality: valid_attributes }, session: valid_session
        }.to change(Municipality, :count).by(1)
      end

      it 'assigns a newly created municipality as @municipality' do
        post :create, params: { municipality: valid_attributes }, session: valid_session
        expect(assigns(:municipality)).to be_a(Municipality)
        expect(assigns(:municipality)).to be_persisted
      end

      it 'redirects to the created municipality' do
        post :create, params: { municipality: valid_attributes }, session: valid_session
        expect(response).to redirect_to(municipalities_url)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved municipality as @municipality' do
        post :create, params: { municipality: invalid_attributes }, session: valid_session
        expect(assigns(:municipality)).to be_a_new(Municipality)
      end

      it "re-renders the 'new' template" do
        post :create, params: { municipality: invalid_attributes }, session: valid_session
        expect(response).to render_template('new')
      end

      it 'too long name' do
        post :create, params: { municipality: { name: 'x' * 200 } }, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'updates the requested municipality' do
        municipality = Municipality.create! valid_attributes
        new_name = "#{municipality.name} updated"
        put :update, params: { id: municipality.to_param, municipality: { name: new_name } }, session: valid_session
        municipality.reload
        expect(municipality.name).to eq(new_name)
      end

      it 'assigns the requested municipality as @municipality' do
        municipality = Municipality.create! valid_attributes
        put :update, params: { id: municipality.to_param, municipality: valid_attributes}, session: valid_session
        expect(assigns(:municipality)).to eq(municipality)
      end

      it 'redirects to the municipality' do
        municipality = Municipality.create! valid_attributes
        put :update, params: { id: municipality.to_param, municipality: valid_attributes}, session: valid_session
        expect(response).to redirect_to(municipalities_url)
      end
    end

    context 'with invalid params' do
      it 'assigns the municipality as @municipality' do
        municipality = Municipality.create! valid_attributes
        put :update, params: { id: municipality.to_param, municipality: invalid_attributes}, session: valid_session
        expect(assigns(:municipality)).to eq(municipality)
      end

      it "re-renders the 'edit' template" do
        municipality = Municipality.create! valid_attributes
        put :update, params: { id: municipality.to_param, municipality: invalid_attributes}, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested municipality' do
      municipality = Municipality.create! valid_attributes
      expect {
        delete :destroy, params: { id: municipality.to_param }, session: valid_session
      }.to change(Municipality, :count).by(-1)
    end

    it 'redirects to the municipalities list' do
      municipality = Municipality.create! valid_attributes
      delete :destroy, params: { id: municipality.to_param }, session: valid_session
      expect(response).to redirect_to(municipalities_url)
    end
  end
end
