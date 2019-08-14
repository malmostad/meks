RSpec.describe LoginController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/login').to route_to('login#new')
    end

    it 'routes to #create' do
      expect(post: '/login').to route_to('login#create')
    end

    it 'routes to #destroy' do
      expect(get: '/logout').to route_to('login#destroy')
    end
  end
end
