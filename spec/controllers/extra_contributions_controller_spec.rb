RSpec.describe ExtraContributionsController, type: :controller do
  let(:valid_person) {
    Person.create!(name: 'Valid person')
  }

  let(:extra_contribution_type) {
    ExtraContributionType.create!(name: 'Valid name')
  }

  let(:valid_attributes) {
    {
      extra_contribution_type_id: extra_contribution_type.id,
      person_id: valid_person.id,
      period_start: '2018-01-01',
      period_end: '2018-12-31',
      fee: 1234,
      expense: 4321,
      contractor_name: 'Firstname familyname',
      contractor_birthday: '1980-01-15',
      contactor_employee_number: 123_456
    }
  }

  let(:invalid_attributes) {
    valid_attributes.merge(
      fee: 'abc'
    )
  }

  describe 'GET #new' do
    it 'assigns a new extra_contribution as @extra_contribution' do
      get :new, params: { person_id: valid_person.id }, session: valid_session
      expect(assigns(:extra_contribution)).to be_a_new(ExtraContribution)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested extra_contribution as @extra_contribution' do
      extra_contribution = ExtraContribution.create! valid_attributes
      get :edit, params: { person_id: valid_person.id, id: extra_contribution.to_param }, session: valid_session
      expect(assigns(:extra_contribution)).to eq(extra_contribution)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new ExtraContribution' do
        expect {
          post :create, params: { person_id: valid_person.id, extra_contribution: valid_attributes}, session: valid_session
        }.to change(ExtraContribution, :count).by(1)
      end

      it 'assigns a newly created extra_contribution as @extra_contribution' do
        post :create, params: { person_id: valid_person.id, extra_contribution: valid_attributes}, session: valid_session
        expect(assigns(:extra_contribution)).to be_a(ExtraContribution)
        expect(assigns(:extra_contribution)).to be_persisted
      end

      it 'redirects to the show person economy' do
        post :create, params: { person_id: valid_person.id, extra_contribution: valid_attributes}, session: valid_session
        expect(response).to redirect_to(person_show_costs_path(valid_person))
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved extra_contribution as @extra_contribution' do
        post :create, params: { person_id: valid_person.id, extra_contribution: invalid_attributes}, session: valid_session
        expect(assigns(:extra_contribution)).to be_a_new(ExtraContribution)
      end

      it 're-renders the new template' do
        post :create, params: { person_id: valid_person.id, extra_contribution: invalid_attributes}, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        { period_start: '2018-01-02' }
      }

      let(:period_end_attributes) {
        { period_end: '2018-01-03' }
      }

      it 'updates the requested extra_contribution' do
        extra_contribution = ExtraContribution.create! valid_attributes
        put :update, params: { person_id: valid_person.id, id: extra_contribution.to_param, extra_contribution: new_attributes}, session: valid_session
        extra_contribution.reload
        expect(extra_contribution.period_start.to_s).to eq(new_attributes[:period_start])
      end

      it 'assigns the requested extra_contribution as @extra_contribution' do
        extra_contribution = ExtraContribution.create! valid_attributes
        put :update, params: { person_id: valid_person.id, id: extra_contribution.to_param, extra_contribution: valid_attributes}, session: valid_session
        expect(assigns(:extra_contribution)).to eq(extra_contribution)
      end

      it 'redirects to show person economy' do
        extra_contribution = ExtraContribution.create! valid_attributes
        put :update, params: { person_id: valid_person.id, id: extra_contribution.to_param, extra_contribution: valid_attributes}, session: valid_session
        expect(response).to redirect_to(person_show_costs_path(valid_person))
      end
    end

    context 'with invalid params' do
      it 'assigns the extra_contribution as @extra_contribution' do
        extra_contribution = ExtraContribution.create! valid_attributes
        put :update, params: { person_id: valid_person.id, id: extra_contribution.to_param, extra_contribution: invalid_attributes}, session: valid_session
        expect(assigns(:extra_contribution)).to eq(extra_contribution)
      end

      it 're-renders the edit template' do
        extra_contribution = ExtraContribution.create! valid_attributes
        put :update, params: { person_id: valid_person.id, id: extra_contribution.to_param, extra_contribution: invalid_attributes}, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested extra_contribution' do
      extra_contribution = ExtraContribution.create! valid_attributes
      expect {
        delete :destroy, params: { person_id: valid_person.id, id: extra_contribution.to_param }, session: valid_session
      }.to change(ExtraContribution, :count).by(-1)
    end

    it 'redirects to the show person economy' do
      extra_contribution = ExtraContribution.create! valid_attributes
      delete :destroy, params: { person_id: valid_person.id, id: extra_contribution.to_param }, session: valid_session
      expect(response).to redirect_to(person_show_costs_path(valid_person))
    end
  end
end
