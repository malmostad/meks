RSpec.describe RefugeesController, type: :routing do
  describe 'routing' do

    it 'routes to #index' do
      expect(get: '/people').to route_to('refugees#search')
    end

    it 'routes to #new' do
      expect(get: '/people/new').to route_to('refugees#new')
    end

    it 'routes to #show' do
      expect(get: '/people/1').to route_to('refugees#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/people/1/edit').to route_to('refugees#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/people').to route_to('refugees#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/people/1').to route_to('refugees#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/people/1').to route_to('refugees#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/people/1').to route_to('refugees#destroy', id: '1')
    end

  end
end
