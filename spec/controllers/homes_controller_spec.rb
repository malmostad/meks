RSpec.describe HomesController, type: :controller do
  let(:valid_attributes) {
    { name: 'Home', type_of_cost: 'cost_per_day' }
  }

  let(:invalid_attributes) {
    { name: '' }
  }

  describe 'GET #index' do
    it 'assigns all homes as @homes' do
      home = Home.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:homes)).to eq([home])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested home as @home' do
      home = Home.create! valid_attributes
      get :show, params: { id: home.to_param }, session: valid_session
      expect(assigns(:home)).to eq(home)
    end
  end

  describe 'GET #new' do
    it 'assigns a new home as @home' do
      get :new, params: {}, session: valid_session
      expect(assigns(:home)).to be_a_new(Home)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested home as @home' do
      home = Home.create! valid_attributes
      get :edit, params: { id: home.to_param }, session: valid_session
      expect(assigns(:home)).to eq(home)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Home' do
        expect {
          post :create, params: { home: valid_attributes }, session: valid_session
        }.to change(Home, :count).by(1)
      end

      it 'assigns a newly created home as @home' do
        post :create, params: { home: valid_attributes }, session: valid_session
        expect(assigns(:home)).to be_a(Home)
        expect(assigns(:home)).to be_persisted
      end

      it 'redirects to the created home' do
        post :create, params: { home: valid_attributes }, session: valid_session
        expect(response).to redirect_to(Home.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved home as @home' do
        post :create, params: { home: invalid_attributes }, session: valid_session
        expect(assigns(:home)).to be_a_new(Home)
      end

      it "re-renders the 'new' template" do
        post :create, params: { home: invalid_attributes }, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        { name: 'Home updated', phone: '123 123' }
      }

      it 'updates the requested home' do
        home = Home.create! valid_attributes
        put :update, params: { id: home.to_param, home: new_attributes}, session: valid_session
        home.reload
        expect(home.name).to eq(new_attributes[:name])
        expect(home.phone).to eq(new_attributes[:phone])
      end

      it 'assigns the requested home as @home' do
        home = Home.create! valid_attributes
        put :update, params: { id: home.to_param, home: valid_attributes}, session: valid_session
        expect(assigns(:home)).to eq(home)
      end

      it 'redirects to the home' do
        home = Home.create! valid_attributes
        put :update, params: { id: home.to_param, home: valid_attributes}, session: valid_session
        expect(response).to redirect_to(home)
      end
    end

    context 'with invalid params' do
      it 'assigns the home as @home' do
        home = Home.create! valid_attributes
        put :update, params: { id: home.to_param, home: invalid_attributes}, session: valid_session
        expect(assigns(:home)).to eq(home)
      end

      it "re-renders the 'edit' template" do
        home = Home.create! valid_attributes
        put :update, params: { id: home.to_param, home: invalid_attributes}, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'Cost nested attributes' do
    it 'new home not to have a cost' do
      attributes = {
        name: 'Firstname Lastname',
        type_of_cost: 'cost_per_day',
        costs_attributes: []
      }

      post :create, params: { home: attributes }, session: valid_session
      expect(assigns(:home)).to be_persisted
      expect(Home.last.costs.size).to eq(0)
    end
  end
end
