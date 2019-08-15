RSpec.describe PersonExtraCostsController, type: :controller do
  let(:valid_person) {
    Person.create!(name: 'Valid person')
  }

  let(:valid_attributes) {
    {
      person_id: valid_person.id,
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
    it 'assigns a new person_extra_cost as @person_extra_cost' do
      get :new, params: { person_id: valid_person.id }, session: valid_session
      expect(assigns(:person_extra_cost)).to be_a_new(PersonExtraCost)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested person_extra_cost as @person_extra_cost' do
      person_extra_cost = PersonExtraCost.create! valid_attributes
      get :edit, params: { person_id: valid_person.id, id: person_extra_cost.to_param }, session: valid_session
      expect(assigns(:person_extra_cost)).to eq(person_extra_cost)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new PersonExtraCost' do
        expect {
          post :create, params: { person_id: valid_person.id, person_extra_cost: valid_attributes}, session: valid_session
        }.to change(PersonExtraCost, :count).by(1)
      end

      it 'assigns a newly created person_extra_cost as @person_extra_cost' do
        post :create, params: { person_id: valid_person.id, person_extra_cost: valid_attributes}, session: valid_session
        expect(assigns(:person_extra_cost)).to be_a(PersonExtraCost)
        expect(assigns(:person_extra_cost)).to be_persisted
      end

      it 'redirects to the show person economy' do
        post :create, params: { person_id: valid_person.id, person_extra_cost: valid_attributes}, session: valid_session
        expect(response).to redirect_to(person_show_costs_path(valid_person))
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved person_extra_cost as @person_extra_cost' do
        post :create, params: { person_id: valid_person.id, person_extra_cost: invalid_attributes}, session: valid_session
        expect(assigns(:person_extra_cost)).to be_a_new(PersonExtraCost)
      end

      it 're-renders the new template' do
        post :create, params: { person_id: valid_person.id, person_extra_cost: invalid_attributes}, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        { date: '2018-01-02' }
      }

      it 'updates the requested person_extra_cost' do
        person_extra_cost = PersonExtraCost.create! valid_attributes
        put :update, params: { person_id: valid_person.id, id: person_extra_cost.to_param, person_extra_cost: new_attributes}, session: valid_session
        person_extra_cost.reload
        expect(person_extra_cost.date.to_s).to eq(new_attributes[:date])
      end

      it 'assigns the requested person_extra_cost as @person_extra_cost' do
        person_extra_cost = PersonExtraCost.create! valid_attributes
        put :update, params: { person_id: valid_person.id, id: person_extra_cost.to_param, person_extra_cost: valid_attributes}, session: valid_session
        expect(assigns(:person_extra_cost)).to eq(person_extra_cost)
      end

      it 'redirects to show person economy' do
        person_extra_cost = PersonExtraCost.create! valid_attributes
        put :update, params: { person_id: valid_person.id, id: person_extra_cost.to_param, person_extra_cost: valid_attributes}, session: valid_session
        expect(response).to redirect_to(person_show_costs_path(valid_person))
      end
    end

    context 'with invalid params' do
      it 'assigns the person_extra_cost as @person_extra_cost' do
        person_extra_cost = PersonExtraCost.create! valid_attributes
        put :update, params: { person_id: valid_person.id, id: person_extra_cost.to_param, person_extra_cost: invalid_attributes}, session: valid_session
        expect(assigns(:person_extra_cost)).to eq(person_extra_cost)
      end

      it 're-renders the edit template' do
        person_extra_cost = PersonExtraCost.create! valid_attributes
        put :update, params: { person_id: valid_person.id, id: person_extra_cost.to_param, person_extra_cost: invalid_attributes}, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested person_extra_cost' do
      person_extra_cost = PersonExtraCost.create! valid_attributes
      expect {
        delete :destroy, params: { person_id: valid_person.id, id: person_extra_cost.to_param }, session: valid_session
      }.to change(PersonExtraCost, :count).by(-1)
    end

    it 'redirects to the show person economy' do
      person_extra_cost = PersonExtraCost.create! valid_attributes
      delete :destroy, params: { person_id: valid_person.id, id: person_extra_cost.to_param }, session: valid_session
      expect(response).to redirect_to(person_show_costs_path(valid_person))
    end
  end
end
