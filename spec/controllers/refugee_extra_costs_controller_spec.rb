RSpec.describe RefugeeExtraCostsController, type: :controller do
  let(:valid_refugee) {
    Refugee.create!(name: 'Valid refugee')
  }

  let(:valid_attributes) {
    {
      refugee_id: valid_refugee.id,
      date: '2018-01-01',
      amount: 1234,
      comment: 'Foo bar'
    }
  }

  let(:invalid_attributes) {
    valid_attributes.merge(
      amount: 'abc'
    )
  }

  describe 'GET #new' do
    it 'assigns a new refugee_extra_cost as @refugee_extra_cost' do
      get :new, params: { refugee_id: valid_refugee.id }, session: valid_session
      expect(assigns(:refugee_extra_cost)).to be_a_new(RefugeeExtraCost)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested refugee_extra_cost as @refugee_extra_cost' do
      refugee_extra_cost = RefugeeExtraCost.create! valid_attributes
      get :edit, params: { refugee_id: valid_refugee.id, id: refugee_extra_cost.to_param }, session: valid_session
      expect(assigns(:refugee_extra_cost)).to eq(refugee_extra_cost)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new RefugeeExtraCost' do
        expect {
          post :create, params: { refugee_id: valid_refugee.id, refugee_extra_cost: valid_attributes}, session: valid_session
        }.to change(RefugeeExtraCost, :count).by(1)
      end

      it 'assigns a newly created refugee_extra_cost as @refugee_extra_cost' do
        post :create, params: { refugee_id: valid_refugee.id, refugee_extra_cost: valid_attributes}, session: valid_session
        expect(assigns(:refugee_extra_cost)).to be_a(RefugeeExtraCost)
        expect(assigns(:refugee_extra_cost)).to be_persisted
      end

      it 'redirects to the show refugee economy' do
        post :create, params: { refugee_id: valid_refugee.id, refugee_extra_cost: valid_attributes}, session: valid_session
        expect(response).to redirect_to(refugee_show_costs_path(valid_refugee))
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved refugee_extra_cost as @refugee_extra_cost' do
        post :create, params: { refugee_id: valid_refugee.id, refugee_extra_cost: invalid_attributes}, session: valid_session
        expect(assigns(:refugee_extra_cost)).to be_a_new(RefugeeExtraCost)
      end

      it 're-renders the new template' do
        post :create, params: { refugee_id: valid_refugee.id, refugee_extra_cost: invalid_attributes}, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        { date: '2018-01-02' }
      }

      it 'updates the requested refugee_extra_cost' do
        refugee_extra_cost = RefugeeExtraCost.create! valid_attributes
        put :update, params: { refugee_id: valid_refugee.id, id: refugee_extra_cost.to_param, refugee_extra_cost: new_attributes}, session: valid_session
        refugee_extra_cost.reload
        expect(refugee_extra_cost.date.to_s).to eq(new_attributes[:date])
      end

      it 'assigns the requested refugee_extra_cost as @refugee_extra_cost' do
        refugee_extra_cost = RefugeeExtraCost.create! valid_attributes
        put :update, params: { refugee_id: valid_refugee.id, id: refugee_extra_cost.to_param, refugee_extra_cost: valid_attributes}, session: valid_session
        expect(assigns(:refugee_extra_cost)).to eq(refugee_extra_cost)
      end

      it 'redirects to show refugee economy' do
        refugee_extra_cost = RefugeeExtraCost.create! valid_attributes
        put :update, params: { refugee_id: valid_refugee.id, id: refugee_extra_cost.to_param, refugee_extra_cost: valid_attributes}, session: valid_session
        expect(response).to redirect_to(refugee_show_costs_path(valid_refugee))
      end
    end

    context 'with invalid params' do
      it 'assigns the refugee_extra_cost as @refugee_extra_cost' do
        refugee_extra_cost = RefugeeExtraCost.create! valid_attributes
        put :update, params: { refugee_id: valid_refugee.id, id: refugee_extra_cost.to_param, refugee_extra_cost: invalid_attributes}, session: valid_session
        expect(assigns(:refugee_extra_cost)).to eq(refugee_extra_cost)
      end

      it 're-renders the edit template' do
        refugee_extra_cost = RefugeeExtraCost.create! valid_attributes
        put :update, params: { refugee_id: valid_refugee.id, id: refugee_extra_cost.to_param, refugee_extra_cost: invalid_attributes}, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested refugee_extra_cost' do
      refugee_extra_cost = RefugeeExtraCost.create! valid_attributes
      expect {
        delete :destroy, params: { refugee_id: valid_refugee.id, id: refugee_extra_cost.to_param }, session: valid_session
      }.to change(RefugeeExtraCost, :count).by(-1)
    end

    it 'redirects to the show refugee economy' do
      refugee_extra_cost = RefugeeExtraCost.create! valid_attributes
      delete :destroy, params: { refugee_id: valid_refugee.id, id: refugee_extra_cost.to_param }, session: valid_session
      expect(response).to redirect_to(refugee_show_costs_path(valid_refugee))
    end
  end
end
