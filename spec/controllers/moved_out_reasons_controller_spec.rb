RSpec.describe MovedOutReasonsController, type: :controller do
  let(:valid_attributes) {
    { name: 'Flyttat' }
  }

  let(:invalid_attributes) {
    { name: nil }
  }

  describe 'GET #index' do
    it 'assigns all moved_out_reasons as @moved_out_reasons' do
      moved_out_reason = MovedOutReason.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:moved_out_reasons)).to eq([moved_out_reason])
    end
  end

  describe 'GET #new' do
    it 'assigns a new moved_out_reason as @moved_out_reason' do
      get :new, params: {}, session: valid_session
      expect(assigns(:moved_out_reason)).to be_a_new(MovedOutReason)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested moved_out_reason as @moved_out_reason' do
      moved_out_reason = MovedOutReason.create! valid_attributes
      get :edit, params: { id: moved_out_reason.to_param }, session: valid_session
      expect(assigns(:moved_out_reason)).to eq(moved_out_reason)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new MovedOutReason' do
        expect {
          post :create, params: { moved_out_reason: valid_attributes }, session: valid_session
        }.to change(MovedOutReason, :count).by(1)
      end

      it 'assigns a newly created moved_out_reason as @moved_out_reason' do
        post :create, params: { moved_out_reason: valid_attributes }, session: valid_session
        expect(assigns(:moved_out_reason)).to be_a(MovedOutReason)
        expect(assigns(:moved_out_reason)).to be_persisted
      end

      it 'redirects to the created moved_out_reason' do
        post :create, params: { moved_out_reason: valid_attributes }, session: valid_session
        expect(response).to redirect_to(moved_out_reasons_url)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved moved_out_reason as @moved_out_reason' do
        post :create, params: { moved_out_reason: invalid_attributes }, session: valid_session
        expect(assigns(:moved_out_reason)).to be_a_new(MovedOutReason)
      end

      it "re-renders the 'new' template" do
        post :create, params: { moved_out_reason: invalid_attributes }, session: valid_session
        expect(response).to render_template('new')
      end

      it 'too long name' do
        post :create, params: { moved_out_reason: { name: 'x' * 200 } }, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'updates the requested moved_out_reason' do
        moved_out_reason = MovedOutReason.create! valid_attributes
        new_name = "#{moved_out_reason.name} updated"
        put :update, params: { id: moved_out_reason.to_param, moved_out_reason: { name: new_name } }, session: valid_session
        moved_out_reason.reload
        expect(moved_out_reason.name).to eq(new_name)
      end

      it 'assigns the requested moved_out_reason as @moved_out_reason' do
        moved_out_reason = MovedOutReason.create! valid_attributes
        put :update, params: { id: moved_out_reason.to_param, moved_out_reason: valid_attributes}, session: valid_session
        expect(assigns(:moved_out_reason)).to eq(moved_out_reason)
      end

      it 'redirects to the moved_out_reason' do
        moved_out_reason = MovedOutReason.create! valid_attributes
        put :update, params: { id: moved_out_reason.to_param, moved_out_reason: valid_attributes}, session: valid_session
        expect(response).to redirect_to(moved_out_reasons_url)
      end
    end

    context 'with invalid params' do
      it 'assigns the moved_out_reason as @moved_out_reason' do
        moved_out_reason = MovedOutReason.create! valid_attributes
        put :update, params: { id: moved_out_reason.to_param, moved_out_reason: invalid_attributes}, session: valid_session
        expect(assigns(:moved_out_reason)).to eq(moved_out_reason)
      end

      it "re-renders the 'edit' template" do
        moved_out_reason = MovedOutReason.create! valid_attributes
        put :update, params: { id: moved_out_reason.to_param, moved_out_reason: invalid_attributes}, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested moved_out_reason' do
      moved_out_reason = MovedOutReason.create! valid_attributes
      expect {
        delete :destroy, params: { id: moved_out_reason.to_param }, session: valid_session
      }.to change(MovedOutReason, :count).by(-1)
    end

    it 'redirects to the moved_out_reasons list' do
      moved_out_reason = MovedOutReason.create! valid_attributes
      delete :destroy, params: { id: moved_out_reason.to_param }, session: valid_session
      expect(response).to redirect_to(moved_out_reasons_url)
    end
  end
end
