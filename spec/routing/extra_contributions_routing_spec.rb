RSpec.describe ExtraContributionsController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/people/1/extra_contributions/new').to be_routable
    end

    it 'routes to #edit' do
      expect(get: '/people/1/extra_contributions/1/edit').to be_routable
    end

    it 'routes to #create' do
      expect(post: '/people/1/extra_contributions').to be_routable
    end

    it 'routes to #update via PUT' do
      expect(put: '/people/1/extra_contributions/1').to be_routable
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/people/1/extra_contributions/1').to be_routable
    end

    it 'routes to #destroy' do
      expect(delete: '/people/1/extra_contributions/1').to be_routable
    end
  end
end
