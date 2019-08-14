RSpec.describe TargetGroupsController, type: :routing do
  describe 'routing' do

    it 'routes to #index' do
      expect(get: '/target_groups').to route_to('target_groups#index')
    end

    it 'routes to #new' do
      expect(get: '/target_groups/new').to route_to('target_groups#new')
    end

    it 'routes to #edit' do
      expect(get: '/target_groups/1/edit').to route_to('target_groups#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/target_groups').to route_to('target_groups#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/target_groups/1').to route_to('target_groups#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/target_groups/1').to route_to('target_groups#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/target_groups/1').to route_to('target_groups#destroy', id: '1')
    end

  end
end
