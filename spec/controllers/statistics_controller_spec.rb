RSpec.describe StatisticsController, type: :controller do
  describe 'GET #index' do
    it 'should render the index view' do
      get :index, params: {}, session: valid_session
      expect(response).to render_template :index
    end
  end
end
