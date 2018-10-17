RSpec.describe ExtraContributionTypesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/extra_contribution_types').to route_to('extra_contribution_types#index')
    end

    it 'routes to #new' do
      expect(get: '/extra_contribution_types/new').to route_to('extra_contribution_types#new')
    end

    it 'routes to #edit' do
      expect(get: '/extra_contribution_types/1/edit').to route_to('extra_contribution_types#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/extra_contribution_types').to route_to('extra_contribution_types#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/extra_contribution_types/1').to route_to('extra_contribution_types#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/extra_contribution_types/1').to route_to('extra_contribution_types#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/extra_contribution_types/1').to route_to('extra_contribution_types#destroy', id: '1')
    end
  end
end
