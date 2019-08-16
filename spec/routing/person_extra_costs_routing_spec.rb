RSpec.describe PersonExtraCostsController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/people/1/person_extra_costs/new').to be_routable
    end

    it 'routes to #edit' do
      expect(get: '/people/1/person_extra_costs/1/edit').to be_routable
    end

    it 'routes to #create' do
      expect(post: '/people/1/person_extra_costs').to be_routable
    end

    it 'routes to #update via PUT' do
      expect(put: '/people/1/person_extra_costs/1').to be_routable
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/people/1/person_extra_costs/1').to be_routable
    end

    it 'routes to #destroy' do
      expect(delete: '/people/1/person_extra_costs/1').to be_routable
    end
  end
end
