RSpec.describe TargetGroupsController, type: :controller do

  let(:valid_attributes) {
    { name: 'Target group' }
  }

  let(:invalid_attributes) {
    { name: '' }
  }

  describe 'GET #index' do
    it 'assigns all target_groups as @target_groups' do
      target_group = TargetGroup.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:target_groups)).to eq([target_group])
    end
  end

  describe 'GET #new' do
    it 'assigns a new target_group as @target_group' do
      get :new, params: {}, session: valid_session
      expect(assigns(:target_group)).to be_a_new(TargetGroup)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested target_group as @target_group' do
      target_group = TargetGroup.create! valid_attributes
      get :edit, params: { id: target_group.to_param }, session: valid_session
      expect(assigns(:target_group)).to eq(target_group)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new TargetGroup' do
        expect {
          post :create, params: { target_group: valid_attributes }, session: valid_session
        }.to change(TargetGroup, :count).by(1)
      end

      it 'assigns a newly created target_group as @target_group' do
        post :create, params: { target_group: valid_attributes }, session: valid_session
        expect(assigns(:target_group)).to be_a(TargetGroup)
        expect(assigns(:target_group)).to be_persisted
      end

      it 'redirects to the target_group index' do
        post :create, params: { target_group: valid_attributes }, session: valid_session
        expect(response).to redirect_to(TargetGroup)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved target_group as @target_group' do
        post :create, params: { target_group: invalid_attributes }, session: valid_session
        expect(assigns(:target_group)).to be_a_new(TargetGroup)
      end

      it "re-renders the 'new' template" do
        post :create, params: { target_group: invalid_attributes }, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        { name: 'Updated name' }
      }

      it 'updates the requested target_group' do
        target_group = TargetGroup.create! valid_attributes
        put :update, params: { id: target_group.to_param, target_group: new_attributes}, session: valid_session
        target_group.reload
        expect(target_group.name).to eq(new_attributes[:name])
      end

      it 'assigns the requested target_group as @target_group' do
        target_group = TargetGroup.create! valid_attributes
        put :update, params: { id: target_group.to_param, target_group: valid_attributes}, session: valid_session
        expect(assigns(:target_group)).to eq(target_group)
      end

      it 'redirects to the target_group index' do
        target_group = TargetGroup.create! valid_attributes
        put :update, params: { id: target_group.to_param, target_group: valid_attributes}, session: valid_session
        expect(response).to redirect_to(TargetGroup)
      end
    end

    context 'with invalid params' do
      it 'assigns the target_group as @target_group' do
        target_group = TargetGroup.create! valid_attributes
        put :update, params: { id: target_group.to_param, target_group: invalid_attributes}, session: valid_session
        expect(assigns(:target_group)).to eq(target_group)
      end

      it "re-renders the 'edit' template" do
        target_group = TargetGroup.create! valid_attributes
        put :update, params: { id: target_group.to_param, target_group: invalid_attributes}, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested target_group' do
      target_group = TargetGroup.create! valid_attributes
      expect {
        delete :destroy, params: { id: target_group.to_param }, session: valid_session
      }.to change(TargetGroup, :count).by(-1)
    end

    it 'redirects to the target_groups list' do
      target_group = TargetGroup.create! valid_attributes
      delete :destroy, params: { id: target_group.to_param }, session: valid_session
      expect(response).to redirect_to(target_groups_url)
    end
  end

end
