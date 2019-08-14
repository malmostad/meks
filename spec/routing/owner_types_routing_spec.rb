RSpec.describe OwnerTypesController, type: :routing do
  describe 'routing' do

    it 'routes to #index' do
      expect(get: '/owner_types').to route_to('owner_types#index')
    end

    it 'routes to #new' do
      expect(get: '/owner_types/new').to route_to('owner_types#new')
    end

    it 'routes to #edit' do
      expect(get: '/owner_types/1/edit').to route_to('owner_types#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/owner_types').to route_to('owner_types#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/owner_types/1').to route_to('owner_types#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/owner_types/1').to route_to('owner_types#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/owner_types/1').to route_to('owner_types#destroy', id: '1')
    end

  end
end
