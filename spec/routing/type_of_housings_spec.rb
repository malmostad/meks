RSpec.describe TypeOfHousingsController, type: :routing do
  describe 'routing' do

    it 'routes to #index' do
      expect(get: '/type_of_housings').to route_to('type_of_housings#index')
    end

    it 'routes to #new' do
      expect(get: '/type_of_housings/new').to route_to('type_of_housings#new')
    end

    it 'routes to #edit' do
      expect(get: '/type_of_housings/1/edit').to route_to('type_of_housings#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/type_of_housings').to route_to('type_of_housings#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/type_of_housings/1').to route_to('type_of_housings#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/type_of_housings/1').to route_to('type_of_housings#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/type_of_housings/1').to route_to('type_of_housings#destroy', id: '1')
    end

  end
end
