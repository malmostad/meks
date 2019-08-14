RSpec.describe TypeOfRelationshipsController, type: :controller do
  let(:valid_attributes) {
    { name: 'Type of relationship' }
  }

  let(:invalid_attributes) {
    { name: '' }
  }

  describe 'GET #index' do
    it 'assigns all type_of_relationships as @type_of_relationships' do
      type_of_relationship = TypeOfRelationship.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:type_of_relationships)).to eq([type_of_relationship])
    end
  end

  describe 'GET #new' do
    it 'assigns a new type_of_relationship as @type_of_relationship' do
      get :new, params: {}, session: valid_session
      expect(assigns(:type_of_relationship)).to be_a_new(TypeOfRelationship)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested type_of_relationship as @type_of_relationship' do
      type_of_relationship = TypeOfRelationship.create! valid_attributes
      get :edit, params: { id: type_of_relationship.to_param }, session: valid_session
      expect(assigns(:type_of_relationship)).to eq(type_of_relationship)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new TypeOfRelationship' do
        expect {
          post :create, params: { type_of_relationship: valid_attributes }, session: valid_session
        }.to change(TypeOfRelationship, :count).by(1)
      end

      it 'assigns a newly created type_of_relationship as @type_of_relationship' do
        post :create, params: { type_of_relationship: valid_attributes }, session: valid_session
        expect(assigns(:type_of_relationship)).to be_a(TypeOfRelationship)
        expect(assigns(:type_of_relationship)).to be_persisted
      end

      it 'redirects to the type_of_relationships index' do
        post :create, params: { type_of_relationship: valid_attributes }, session: valid_session
        expect(response).to redirect_to(TypeOfRelationship)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved type_of_relationship as @type_of_relationship' do
        post :create, params: { type_of_relationship: invalid_attributes }, session: valid_session
        expect(assigns(:type_of_relationship)).to be_a_new(TypeOfRelationship)
      end

      it "re-renders the 'new' template" do
        post :create, params: { type_of_relationship: invalid_attributes }, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        { name: 'Name updated' }
      }

      it 'updates the requested type_of_relationship' do
        type_of_relationship = TypeOfRelationship.create! valid_attributes
        put :update, params: { id: type_of_relationship.to_param, type_of_relationship: new_attributes}, session: valid_session
        type_of_relationship.reload
        expect(type_of_relationship.name).to eq(new_attributes[:name])
      end

      it 'assigns the requested type_of_relationship as @type_of_relationship' do
        type_of_relationship = TypeOfRelationship.create! valid_attributes
        put :update, params: { id: type_of_relationship.to_param, type_of_relationship: valid_attributes}, session: valid_session
        expect(assigns(:type_of_relationship)).to eq(type_of_relationship)
      end

      it 'redirects to the type_of_relationship' do
        type_of_relationship = TypeOfRelationship.create! valid_attributes
        put :update, params: { id: type_of_relationship.to_param, type_of_relationship: valid_attributes}, session: valid_session
        expect(response).to redirect_to(TypeOfRelationship)
      end
    end

    context 'with invalid params' do
      it 'assigns the type_of_relationship as @type_of_relationship' do
        type_of_relationship = TypeOfRelationship.create! valid_attributes
        put :update, params: { id: type_of_relationship.to_param, type_of_relationship: invalid_attributes}, session: valid_session
        expect(assigns(:type_of_relationship)).to eq(type_of_relationship)
      end

      it "re-renders the 'edit' template" do
        type_of_relationship = TypeOfRelationship.create! valid_attributes
        put :update, params: { id: type_of_relationship.to_param, type_of_relationship: invalid_attributes}, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested type_of_relationship' do
      type_of_relationship = TypeOfRelationship.create! valid_attributes
      expect {
        delete :destroy, params: { id: type_of_relationship.to_param }, session: valid_session
      }.to change(TypeOfRelationship, :count).by(-1)
    end

    it 'redirects to the type_of_relationships list' do
      type_of_relationship = TypeOfRelationship.create! valid_attributes
      delete :destroy, params: { id: type_of_relationship.to_param }, session: valid_session
      expect(response).to redirect_to(type_of_relationships_url)
    end
  end

end
