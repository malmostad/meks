RSpec.describe CountriesController, type: :controller do
  let(:valid_attributes) {
    { name: 'Sverige' }
  }

  let(:invalid_attributes) {
    { name: nil }
  }

  describe 'GET #index' do
    it 'assigns all countries as @countries' do
      country = Country.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:countries)).to eq([country])
    end
  end

  describe 'GET #new' do
    it 'assigns a new country as @country' do
      get :new, params: {}, session: valid_session
      expect(assigns(:country)).to be_a_new(Country)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested country as @country' do
      country = Country.create! valid_attributes
      get :edit, params: { id: country.to_param }, session: valid_session
      expect(assigns(:country)).to eq(country)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Country' do
        expect {
          post :create, params: { country: valid_attributes }, session: valid_session
        }.to change(Country, :count).by(1)
      end

      it 'assigns a newly created country as @country' do
        post :create, params: { country: valid_attributes }, session: valid_session
        expect(assigns(:country)).to be_a(Country)
        expect(assigns(:country)).to be_persisted
      end

      it 'redirects to the created country' do
        post :create, params: { country: valid_attributes }, session: valid_session
        expect(response).to redirect_to(countries_url)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved country as @country' do
        post :create, params: { country: invalid_attributes }, session: valid_session
        expect(assigns(:country)).to be_a_new(Country)
      end

      it "re-renders the 'new' template" do
        post :create, params: { country: invalid_attributes }, session: valid_session
        expect(response).to render_template('new')
      end

      it 'too long name' do
        post :create, params: { country: { name: 'x' * 200 } }, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'updates the requested country' do
        country = Country.create! valid_attributes
        new_name = "#{country.name} updated"
        put :update, params: { id: country.to_param, country: { name: new_name } }, session: valid_session
        country.reload
        expect(country.name).to eq(new_name)
      end

      it 'assigns the requested country as @country' do
        country = Country.create! valid_attributes
        put :update, params: { id: country.to_param, country: valid_attributes}, session: valid_session
        expect(assigns(:country)).to eq(country)
      end

      it 'redirects to the country' do
        country = Country.create! valid_attributes
        put :update, params: { id: country.to_param, country: valid_attributes}, session: valid_session
        expect(response).to redirect_to(countries_url)
      end
    end

    context 'with invalid params' do
      it 'assigns the country as @country' do
        country = Country.create! valid_attributes
        put :update, params: { id: country.to_param, country: invalid_attributes}, session: valid_session
        expect(assigns(:country)).to eq(country)
      end

      it "re-renders the 'edit' template" do
        country = Country.create! valid_attributes
        put :update, params: { id: country.to_param, country: invalid_attributes }, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested country' do
      country = Country.create! valid_attributes
      expect {
        delete :destroy, params: { id: country.to_param }, session: valid_session
      }.to change(Country, :count).by(-1)
    end

    it 'redirects to the countries list' do
      country = Country.create! valid_attributes
      delete :destroy, params: { id: country.to_param }, session: valid_session
      expect(response).to redirect_to(countries_url)
    end
  end
end
