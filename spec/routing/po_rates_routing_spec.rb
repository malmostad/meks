RSpec.describe PoRatesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/po_rates').to route_to('po_rates#index')
    end

    it 'routes to #new' do
      expect(get: '/po_rates/new').to route_to('po_rates#new')
    end

    it 'routes to #edit' do
      expect(get: '/po_rates/1/edit').to route_to('po_rates#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/po_rates').to route_to('po_rates#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/po_rates/1').to route_to('po_rates#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/po_rates/1').to route_to('po_rates#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/po_rates/1').to route_to('po_rates#destroy', id: '1')
    end
  end
end
