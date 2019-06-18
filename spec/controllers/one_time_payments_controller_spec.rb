RSpec.describe OneTimePaymentsController, type: :controller do
  let(:valid_attributes) do
    {
      amount: 123,
      start_date: '2019-01-01',
      end_date: '2019-12-31'
    }
  end

  let(:invalid_attributes) { { amount: nil } }

  describe 'GET #index' do
    it 'assigns all one_time_paymentsas @one_time_payment' do
      one_time_payment = OneTimePayment.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:one_time_payments)).to eq([one_time_payment])
    end
  end

  describe 'GET #new' do
    it 'assigns a new one_time_payment as @one_time_payment' do
      get :new, params: {}, session: valid_session
      expect(assigns(:one_time_payment)).to be_a_new(OneTimePayment)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested one_time_payment as @one_time_payment' do
      one_time_payment = OneTimePayment.create! valid_attributes
      get :edit, params: { id: one_time_payment.to_param }, session: valid_session
      expect(assigns(:one_time_payment)).to eq(one_time_payment)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new OneTimePayment' do
        expect {
          post :create, params: { one_time_payment: valid_attributes }, session: valid_session
        }.to change(OneTimePayment, :count).by(1)
      end

      it 'assigns a newly created one_time_payment as @one_time_payment' do
        post :create, params: { one_time_payment: valid_attributes }, session: valid_session
        expect(assigns(:one_time_payment)).to be_a(OneTimePayment)
        expect(assigns(:one_time_payment)).to be_persisted
      end

      it 'redirects to the created one_time_payment' do
        post :create, params: { one_time_payment: valid_attributes }, session: valid_session
        expect(response).to redirect_to(one_time_payments_url)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved one_time_payment as @one_time_payment' do
        post :create, params: { one_time_payment: invalid_attributes }, session: valid_session
        expect(assigns(:one_time_payment)).to be_a_new(OneTimePayment)
      end

      it 're-renders the "new" template' do
        post :create, params: { one_time_payment: invalid_attributes }, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'updates the requested one_time_payment' do
        one_time_payment = OneTimePayment.create! valid_attributes
        new_amount = 987
        put :update, params: { id: one_time_payment.to_param, one_time_payment: { amount: new_amount } }, session: valid_session
        one_time_payment.reload
        expect(one_time_payment.amount).to eq(new_amount)
      end

      it 'assigns the requested one_time_payment as @one_time_payment' do
        one_time_payment = OneTimePayment.create! valid_attributes
        put :update, params: { id: one_time_payment.to_param, one_time_payment: valid_attributes}, session: valid_session
        expect(assigns(:one_time_payment)).to eq(one_time_payment)
      end

      it 'redirects to the one_time_payment' do
        one_time_payment = OneTimePayment.create! valid_attributes
        put :update, params: { id: one_time_payment.to_param, one_time_payment: valid_attributes}, session: valid_session
        expect(response).to redirect_to(one_time_payments_url)
      end
    end

    context 'with invalid params' do
      it 'assigns the one_time_payment as @one_time_payment' do
        one_time_payment = OneTimePayment.create! valid_attributes
        put :update, params: { id: one_time_payment.to_param, one_time_payment: invalid_attributes}, session: valid_session
        expect(assigns(:one_time_payment)).to eq(one_time_payment)
      end

      it 're-renders the "edit" template' do
        one_time_payment = OneTimePayment.create! valid_attributes
        put :update, params: { id: one_time_payment.to_param, one_time_payment: invalid_attributes }, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested one_time_payment' do
      one_time_payment = OneTimePayment.create! valid_attributes
      expect {
        delete :destroy, params: { id: one_time_payment.to_param }, session: valid_session
      }.to change(OneTimePayment, :count).by(-1)
    end

    it 'redirects to the one_time_payments list' do
      one_time_payment = OneTimePayment.create! valid_attributes
      delete :destroy, params: { id: one_time_payment.to_param }, session: valid_session
      expect(response).to redirect_to(one_time_payments_url)
    end
  end
end
