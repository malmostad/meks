RSpec.describe RateCategoriesController, type: :controller do
  let(:valid_attributes) {
    { name: 'Foo 0-17', from_age: 0, to_age: 17 }
  }

  let(:rate_category) { create(:rate_category) }

  let(:invalid_attributes) {
    { name: nil }
  }

  describe 'GET #index' do
    it 'assigns all rate_categories as @rate_categories' do
      get :index, params: {}, session: valid_session
      expect(assigns(:rate_categories)).to eq([rate_category])
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested rate_category as @lrate_category' do
      get :edit, params: { id: rate_category.to_param }, session: valid_session
      expect(assigns(:rate_category)).to eq(rate_category)
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        { name: 'RateCategory updated', from_age: 18, to_age: 20 }
      }

      it 'updates the requested rate_category' do
        put :update, params: { id: rate_category.to_param, rate_category: new_attributes}, session: valid_session
        rate_category.reload
        expect(rate_category.name).to eq(new_attributes[:name])
      end

      it 'redirects to the rate_category' do
        put :update, params: { id: rate_category.to_param, rate_category: valid_attributes}, session: valid_session
        expect(response).to redirect_to(rate_categories_path)
      end
    end

    context 'with invalid params' do
      it 'assigns the rate_category as @rate_category' do
        put :update, params: { id: rate_category.to_param, rate_category: invalid_attributes}, session: valid_session
        expect(assigns(:rate_category)).to eq(rate_category)
      end

      it "re-renders the 'edit' template" do
        put :update, params: { id: rate_category.to_param, rate_category: invalid_attributes}, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'Rate category nested attributes for a rate' do
    let(:new_attributes) {
      { name: 'Rate Category updated', age_from: 18, age_to: 20 }
    }
    let (:rate_attributes) {
      { amount: 123, start_date: '2017-01-01', end_date: '2017-03-31' }
    }

    it 'assign a rate for a rate_category' do
      put :update, params: { id: rate_category.to_param, rate_category: new_attributes, rates: [rate: rate_attributes]}, session: valid_session
      expect(assigns(:rate_category)).to be_persisted
    end

    it 'allow a rate for a rate_category' do
      put :update, params: { id: rate_category.to_param, rate_category: new_attributes, rates: [rate: rate_attributes]}, session: valid_session
      expect(assigns(:rate_category)).to eq(rate_category)
    end

    it 'rate_category to have a rate' do
      Rate.create! rate_category: rate_category, amount: 321, start_date: '2018-01-01', end_date: '2018-03-31'
      put :update, params: { id: rate_category.to_param, rate_category: new_attributes, rates: [ rate: rate_attributes]}, session: valid_session
      expect(assigns(:rate_category).rates.size).to eq(1)
    end
  end
end
