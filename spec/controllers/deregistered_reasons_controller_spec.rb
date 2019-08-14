RSpec.describe DeregisteredReasonsController, type: :controller do
  let(:valid_attributes) {
    { name: 'Flyttat' }
  }

  let(:invalid_attributes) {
    { name: nil }
  }

  describe 'GET #index' do
    it 'assigns all deregistered_reasons as @deregistered_reasons' do
      deregistered_reason = DeregisteredReason.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:deregistered_reasons)).to eq([deregistered_reason])
    end
  end

  describe 'GET #new' do
    it 'assigns a new deregistered_reason as @deregistered_reason' do
      get :new, params: {}, session: valid_session
      expect(assigns(:deregistered_reason)).to be_a_new(DeregisteredReason)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested deregistered_reason as @deregistered_reason' do
      deregistered_reason = DeregisteredReason.create! valid_attributes
      get :edit, params: { id: deregistered_reason.to_param }, session: valid_session
      expect(assigns(:deregistered_reason)).to eq(deregistered_reason)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new DeregisteredReason' do
        expect {
          post :create, params: { deregistered_reason: valid_attributes }, session: valid_session
        }.to change(DeregisteredReason, :count).by(1)
      end

      it 'assigns a newly created deregistered_reason as @deregistered_reason' do
        post :create, params: { deregistered_reason: valid_attributes }, session: valid_session
        expect(assigns(:deregistered_reason)).to be_a(DeregisteredReason)
        expect(assigns(:deregistered_reason)).to be_persisted
      end

      it 'redirects to the created deregistered_reason' do
        post :create, params: { deregistered_reason: valid_attributes }, session: valid_session
        expect(response).to redirect_to(deregistered_reasons_url)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved deregistered_reason as @deregistered_reason' do
        post :create, params: { deregistered_reason: invalid_attributes }, session: valid_session
        expect(assigns(:deregistered_reason)).to be_a_new(DeregisteredReason)
      end

      it "re-renders the 'new' template" do
        post :create, params: { deregistered_reason: invalid_attributes }, session: valid_session
        expect(response).to render_template('new')
      end

      it 'too long name' do
        post :create, params: { deregistered_reason: { name: 'x' * 200 } }, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'updates the requested deregistered_reason' do
        deregistered_reason = DeregisteredReason.create! valid_attributes
        new_name = "#{deregistered_reason.name} updated"
        put :update, params: { id: deregistered_reason.to_param, deregistered_reason: { name: new_name } }, session: valid_session
        deregistered_reason.reload
        expect(deregistered_reason.name).to eq(new_name)
      end

      it 'assigns the requested deregistered_reason as @deregistered_reason' do
        deregistered_reason = DeregisteredReason.create! valid_attributes
        put :update, params: { id: deregistered_reason.to_param, deregistered_reason: valid_attributes}, session: valid_session
        expect(assigns(:deregistered_reason)).to eq(deregistered_reason)
      end

      it 'redirects to the deregistered_reason' do
        deregistered_reason = DeregisteredReason.create! valid_attributes
        put :update, params: { id: deregistered_reason.to_param, deregistered_reason: valid_attributes}, session: valid_session
        expect(response).to redirect_to(deregistered_reasons_url)
      end
    end

    context 'with invalid params' do
      it 'assigns the deregistered_reason as @deregistered_reason' do
        deregistered_reason = DeregisteredReason.create! valid_attributes
        put :update, params: { id: deregistered_reason.to_param, deregistered_reason: invalid_attributes}, session: valid_session
        expect(assigns(:deregistered_reason)).to eq(deregistered_reason)
      end

      it "re-renders the 'edit' template" do
        deregistered_reason = DeregisteredReason.create! valid_attributes
        put :update, params: { id: deregistered_reason.to_param, deregistered_reason: invalid_attributes}, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested deregistered_reason' do
      deregistered_reason = DeregisteredReason.create! valid_attributes
      expect {
        delete :destroy, params: { id: deregistered_reason.to_param }, session: valid_session
      }.to change(DeregisteredReason, :count).by(-1)
    end

    it 'redirects to the deregistered_reasons list' do
      deregistered_reason = DeregisteredReason.create! valid_attributes
      delete :destroy, params: { id: deregistered_reason.to_param }, session: valid_session
      expect(response).to redirect_to(deregistered_reasons_url)
    end
  end
end
