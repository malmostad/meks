RSpec.describe OwnerTypesController, type: :controller do

  let(:valid_attributes) {
    { name: 'Owner type' }
  }

  let(:invalid_attributes) {
    { name: 'x' * 200 }
  }

  describe 'GET #index' do
    it 'assigns all owner_type as @owner_types' do
      owner_type = OwnerType.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:owner_types)).to eq([owner_type])
    end
  end

  describe 'GET #new' do
    it 'assigns a new owner_type as @owner_type' do
      get :new, params: {}, session: valid_session
      expect(assigns(:owner_type)).to be_a_new(OwnerType)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested owner_type as @owner_type' do
      owner_type = OwnerType.create! valid_attributes
      get :edit, params: { id: owner_type.to_param }, session: valid_session
      expect(assigns(:owner_type)).to eq(owner_type)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new OwnerType' do
        expect {
          post :create, params: { owner_type: valid_attributes }, session: valid_session
        }.to change(OwnerType, :count).by(1)
      end

      it 'assigns a newly created owner_type as @owner_type' do
        post :create, params: { owner_type: valid_attributes }, session: valid_session
        expect(assigns(:owner_type)).to be_a(OwnerType)
        expect(assigns(:owner_type)).to be_persisted
      end

      it 'redirects to the owner_types index' do
        post :create, params: { owner_type: valid_attributes }, session: valid_session
        expect(response).to redirect_to(owner_types_path)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved owner_type as @owner_type' do
        post :create, params: { owner_type: invalid_attributes }, session: valid_session
        expect(assigns(:owner_type)).to be_a_new(OwnerType)
      end

      it "re-renders the 'new' template" do
        post :create, params: { owner_type: invalid_attributes }, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        { name: 'Owner type updated' }
      }

      it 'updates the requested owner_type' do
        owner_type = OwnerType.create! valid_attributes
        put :update, params: { id: owner_type.to_param, owner_type: new_attributes}, session: valid_session
        owner_type.reload
        expect(owner_type.name).to eq(new_attributes[:name])
      end

      it 'assigns the requested owner_type as @owner_type' do
        owner_type = OwnerType.create! valid_attributes
        put :update, params: { id: owner_type.to_param, owner_type: valid_attributes}, session: valid_session
        expect(assigns(:owner_type)).to eq(owner_type)
      end

      it 'redirects to the owner_types index' do
        owner_type = OwnerType.create! valid_attributes
        put :update, params: { id: owner_type.to_param, owner_type: valid_attributes}, session: valid_session
        expect(response).to redirect_to(owner_types_path)
      end
    end

    context 'with invalid params' do
      it 'assigns the owner_type as @owner_type' do
        owner_type = OwnerType.create! valid_attributes
        put :update, params: { id: owner_type.to_param, owner_type: invalid_attributes}, session: valid_session
        expect(assigns(:owner_type)).to eq(owner_type)
      end

      it "re-renders the 'edit' template" do
        owner_type = OwnerType.create! valid_attributes
        put :update, params: { id: owner_type.to_param, owner_type: invalid_attributes}, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested owner_type' do
      owner_type = OwnerType.create! valid_attributes
      expect {
        delete :destroy, params: { id: owner_type.to_param }, session: valid_session
      }.to change(OwnerType, :count).by(-1)
    end

    it 'redirects to the owner_types list' do
      owner_type = OwnerType.create! valid_attributes
      delete :destroy, params: { id: owner_type.to_param }, session: valid_session
      expect(response).to redirect_to(owner_types_url)
    end
  end
end
