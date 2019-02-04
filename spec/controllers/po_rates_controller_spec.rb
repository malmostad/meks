RSpec.describe PoRatesController, type: :controller do
  let(:valid_attributes) do
    {
      rate_under_65: 30.32,
      rate_between_65_and_81: 30.64,
      rate_from_82: 2.12,
      start_date: '2019-01-01',
      end_date: '2019-12-31'
    }
  end

  let(:invalid_attributes) { { rate_under_65: nil } }

  describe 'GET #index' do
    it 'assigns all po_rates as @po_rates' do
      po_rate = PoRate.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:po_rates)).to eq([po_rate])
    end
  end

  describe 'GET #new' do
    it 'assigns a new po_rate as @po_rate' do
      get :new, params: {}, session: valid_session
      expect(assigns(:po_rate)).to be_a_new(PoRate)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested po_rate as @po_rate' do
      po_rate = PoRate.create! valid_attributes
      get :edit, params: { id: po_rate.to_param }, session: valid_session
      expect(assigns(:po_rate)).to eq(po_rate)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new PoRate' do
        expect {
          post :create, params: { po_rate: valid_attributes }, session: valid_session
        }.to change(PoRate, :count).by(1)
      end

      it 'assigns a newly created po_rate as @po_rate' do
        post :create, params: { po_rate: valid_attributes }, session: valid_session
        expect(assigns(:po_rate)).to be_a(PoRate)
        expect(assigns(:po_rate)).to be_persisted
      end

      it 'redirects to the created po_rate' do
        post :create, params: { po_rate: valid_attributes }, session: valid_session
        expect(response).to redirect_to(po_rates_url)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved po_rate as @po_rate' do
        post :create, params: { po_rate: invalid_attributes }, session: valid_session
        expect(assigns(:po_rate)).to be_a_new(PoRate)
      end

      it 're-renders the "new" template' do
        post :create, params: { po_rate: invalid_attributes }, session: valid_session
        expect(response).to render_template('new')
      end

      it 'too long name' do
        post :create, params: { po_rate: { name: 'x' * 200 } }, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'updates the requested po_rate' do
        po_rate = PoRate.create! valid_attributes
        new_rate = 30.12
        put :update, params: { id: po_rate.to_param, po_rate: { rate_between_65_and_81: new_rate } }, session: valid_session
        po_rate.reload
        expect(po_rate.rate_between_65_and_81).to eq(new_rate)
      end

      it 'assigns the requested po_rate as @po_rate' do
        po_rate = PoRate.create! valid_attributes
        put :update, params: { id: po_rate.to_param, po_rate: valid_attributes}, session: valid_session
        expect(assigns(:po_rate)).to eq(po_rate)
      end

      it 'redirects to the po_rate' do
        po_rate = PoRate.create! valid_attributes
        put :update, params: { id: po_rate.to_param, po_rate: valid_attributes}, session: valid_session
        expect(response).to redirect_to(po_rates_url)
      end
    end

    context 'with invalid params' do
      it 'assigns the po_rate as @po_rate' do
        po_rate = PoRate.create! valid_attributes
        put :update, params: { id: po_rate.to_param, po_rate: invalid_attributes}, session: valid_session
        expect(assigns(:po_rate)).to eq(po_rate)
      end

      it 're-renders the "edit" template' do
        po_rate = PoRate.create! valid_attributes
        put :update, params: { id: po_rate.to_param, po_rate: invalid_attributes }, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested po_rate' do
      po_rate = PoRate.create! valid_attributes
      expect {
        delete :destroy, params: { id: po_rate.to_param }, session: valid_session
      }.to change(PoRate, :count).by(-1)
    end

    it 'redirects to the po_rates list' do
      po_rate = PoRate.create! valid_attributes
      delete :destroy, params: { id: po_rate.to_param }, session: valid_session
      expect(response).to redirect_to(po_rates_url)
    end
  end
end
