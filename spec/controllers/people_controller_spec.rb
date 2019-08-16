RSpec.describe PeopleController, type: :controller do

  let(:valid_attributes) {
    {
      name: 'Firstname Lastname',
      date_of_birth: '2016-01-01',
      ssn_extension: '1234'
    }
  }

  let(:invalid_attributes) {
    {
      name: 'Firstname Lastname',
      date_of_birth: '2016-01-xx',
      ssn_extension: '1234'
    }
  }

  describe 'GET #drafts' do
    it 'assigns all people as @people' do
      person = Person.create! valid_attributes.merge(draft: true)
      get :drafts, params: {}, session: valid_session
      expect(assigns(:people)).to eq([person])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested person as @person' do
      person = Person.create! valid_attributes
      get :show, params: { id: person.to_param }, session: valid_session
      expect(assigns(:person)).to eq(person)
    end
  end

  describe 'GET #new' do
    it 'assigns a new person as @person' do
      get :new, params: {}, session: valid_session
      expect(assigns(:person)).to be_a_new(Person)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested person as @person' do
      person = Person.create! valid_attributes
      get :edit, params: { id: person.to_param }, session: valid_session
      expect(assigns(:person)).to eq(person)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Person' do
        expect {
          post :create, params: { person: valid_attributes }, session: valid_session
        }.to change(Person, :count).by(1)
      end

      it 'assigns a newly created person as @person' do
        post :create, params: { person: valid_attributes }, session: valid_session
        expect(assigns(:person)).to be_a(Person)
        expect(assigns(:person)).to be_persisted
      end

      it 'redirects to the created person' do
        post :create, params: { person: valid_attributes }, session: valid_session
        expect(response).to redirect_to(Person.last)
      end

      it 'make @person a draft if reader role' do
        post :create, params: { person: valid_attributes }, session: valid_session(role: :reader)
        expect(Person.last.draft).to eq(true)
      end

      it "don't make @person a draft if writer role" do
        post :create, params: { person: valid_attributes }, session: valid_session(role: :writer)
        expect(Person.last.draft).to eq(false)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved person as @person' do
        post :create, params: { person: invalid_attributes }, session: valid_session
        expect(assigns(:person)).to be_a_new(Person)
      end

      it "re-renders the 'new' template" do
        post :create, params: { person: invalid_attributes }, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        {
          name: 'Firstname Lastname updated',
          date_of_birth: '2016-01-02',
          ssn_extension: '1235',
          dossier_number: '1234567'
        }
      }

      it 'updates the requested person' do
        person = Person.create! valid_attributes
        put :update, params: { id: person.to_param, person: new_attributes}, session: valid_session
        person.reload
        expect(person.name).to eq(new_attributes[:name])
        expect(person.date_of_birth.to_date.to_s).to eq(new_attributes[:date_of_birth])
        expect(person.ssn_extension.to_s).to eq(new_attributes[:ssn_extension])
        expect(person.dossier_number).to eq(new_attributes[:dossier_number])
      end

      it 'assigns the requested person as @person' do
        person = Person.create! valid_attributes
        put :update, params: { id: person.to_param, person: valid_attributes}, session: valid_session
        expect(assigns(:person)).to eq(person)
      end

      it 'redirects to the person' do
        person = Person.create! valid_attributes
        put :update, params: { id: person.to_param, person: valid_attributes}, session: valid_session
        expect(response).to redirect_to(person)
      end
    end

    context 'with invalid params' do
      it 'assigns the person as @person' do
        person = Person.create! valid_attributes
        put :update, params: { id: person.to_param, person: invalid_attributes}, session: valid_session
        expect(assigns(:person)).to eq(person)
      end

      it "re-renders the 'edit' template" do
        person = Person.create! valid_attributes
        put :update, params: { id: person.to_param, person: invalid_attributes}, session: valid_session
        expect(response).to render_template('edit')
      end

      it "re-renders the 'edit' template if ssn_extension is invalid" do
        person = Person.create! valid_attributes
        put :update, params: { id: person.to_param, person: { ssn_extension: '12345' } }, session: valid_session
        expect(response).to render_template('edit')
      end

      it "re-renders the 'edit' template if date_of_birth is invalid" do
        person = Person.create! valid_attributes
        put :update, params: { id: person.to_param, person: { date_of_birth: '2016-01-xx' } }, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'Placement nested attributes' do
    let(:home) { create(:home) }
    let(:legal_code) { create(:legal_code) }

    let(:placement_attributes) {
      {
        name: 'Firstname Lastname updated',
        placements: {
          home_id: home.id,
          legal_code_id: legal_code.id,
          moved_in_at: '2016-01-02'
        }
      }
    }

    it 'new person to have a placement' do
      attributes = {
        name: 'Firstname Lastname',
        placements_attributes: [{
          home_id: home.id,
          legal_code_id: legal_code.id,
          moved_in_at: '2016-01-02'
        }]
      }
      post :create, params: { person: attributes }, session: valid_session
      expect(assigns(:person)).to be_persisted
      expect(Person.last.placements.size).to eq(1)
    end

    it 'new person not to have a placement' do
      attributes = {
        name: 'Firstname Lastname',
        placements_attributes: []
      }
      post :create, params: { person: attributes }, session: valid_session
      expect(assigns(:person)).to be_persisted
      expect(Person.last.placements.size).to eq(0)
    end

    it "re-renders the 'new' template if placement home_id is present but not moved_in_at" do
      attributes = {
        name: 'Firstname Lastname',
        placements_attributes: [{
          legal_code_id: legal_code.id,
          home_id: home.id
        }]
      }
      post :create, params: { person: attributes }, session: valid_session
      expect(response).to render_template('new')
    end

    it "re-renders the 'new' template if placement legal_code is abscent" do
      attributes = {
        name: 'Firstname Lastname',
        placements_attributes: [{
          moved_in_at: '2016-01-02',
          home_id: home.id
        }]
      }
      post :create, params: { person: attributes }, session: valid_session
      expect(response).to render_template('new')
    end
  end
end
