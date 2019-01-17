RSpec.describe ExtraContributionTypesController, type: :controller do
  let(:valid_attributes) {
    { name: 'ExtraContribution type' }
  }

  let(:invalid_attributes) {
    { name: 'x' * 200 }
  }

  describe 'GET #index' do
    it 'assigns all extra_contribution_type as @extra_contribution_types' do
      extra_contribution_type = ExtraContributionType.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:extra_contribution_types)).to eq([extra_contribution_type])
    end
  end

  describe 'GET #new' do
    it 'assigns a new extra_contribution_type as @extra_contribution_type' do
      get :new, params: {}, session: valid_session
      expect(assigns(:extra_contribution_type)).to be_a_new(ExtraContributionType)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested extra_contribution_type as @extra_contribution_type' do
      extra_contribution_type = ExtraContributionType.create! valid_attributes
      get :edit, params: { id: extra_contribution_type.to_param }, session: valid_session
      expect(assigns(:extra_contribution_type)).to eq(extra_contribution_type)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new ExtraContributionType' do
        expect {
          post :create, params: { extra_contribution_type: valid_attributes }, session: valid_session
        }.to change(ExtraContributionType, :count).by(1)
      end

      it 'assigns a newly created extra_contribution_type as @extra_contribution_type' do
        post :create, params: { extra_contribution_type: valid_attributes }, session: valid_session
        expect(assigns(:extra_contribution_type)).to be_a(ExtraContributionType)
        expect(assigns(:extra_contribution_type)).to be_persisted
      end

      it 'redirects to the extra_contribution_types index' do
        post :create, params: { extra_contribution_type: valid_attributes }, session: valid_session
        expect(response).to redirect_to(extra_contribution_types_path)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved extra_contribution_type as @extra_contribution_type' do
        post :create, params: { extra_contribution_type: invalid_attributes }, session: valid_session
        expect(assigns(:extra_contribution_type)).to be_a_new(ExtraContributionType)
      end

      it 're-renders the "new" template' do
        post :create, params: { extra_contribution_type: invalid_attributes }, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        { name: 'ExtraContribution type updated' }
      }

      it 'updates the requested extra_contribution_type' do
        extra_contribution_type = ExtraContributionType.create! valid_attributes
        put :update, params: { id: extra_contribution_type.to_param, extra_contribution_type: new_attributes}, session: valid_session
        extra_contribution_type.reload
        expect(extra_contribution_type.name).to eq(new_attributes[:name])
      end

      it 'assigns the requested extra_contribution_type as @extra_contribution_type' do
        extra_contribution_type = ExtraContributionType.create! valid_attributes
        put :update, params: { id: extra_contribution_type.to_param, extra_contribution_type: valid_attributes}, session: valid_session
        expect(assigns(:extra_contribution_type)).to eq(extra_contribution_type)
      end

      it 'redirects to the extra_contribution_types index' do
        extra_contribution_type = ExtraContributionType.create! valid_attributes
        put :update, params: { id: extra_contribution_type.to_param, extra_contribution_type: valid_attributes}, session: valid_session
        expect(response).to redirect_to(extra_contribution_types_path)
      end
    end

    context 'with invalid params' do
      it 'assigns the extra_contribution_type as @extra_contribution_type' do
        extra_contribution_type = ExtraContributionType.create! valid_attributes
        put :update, params: { id: extra_contribution_type.to_param, extra_contribution_type: invalid_attributes}, session: valid_session
        expect(assigns(:extra_contribution_type)).to eq(extra_contribution_type)
      end

      it 're-renders the "edit" template' do
        extra_contribution_type = ExtraContributionType.create! valid_attributes
        put :update, params: { id: extra_contribution_type.to_param, extra_contribution_type: invalid_attributes}, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested extra_contribution_type' do
      extra_contribution_type = ExtraContributionType.create! valid_attributes
      expect {
        delete :destroy, params: { id: extra_contribution_type.to_param }, session: valid_session
      }.to change(ExtraContributionType, :count).by(-1)
    end

    it 'redirects to the extra_contribution_types list' do
      extra_contribution_type = ExtraContributionType.create! valid_attributes
      delete :destroy, params: { id: extra_contribution_type.to_param }, session: valid_session
      expect(response).to redirect_to(extra_contribution_types_url)
    end
  end
end
