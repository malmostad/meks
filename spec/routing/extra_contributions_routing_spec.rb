require 'rails_helper'

RSpec.describe ExtraContributionsController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/refugees/1/extra_contributions/new').to be_routable
    end

    it 'routes to #edit' do
      expect(get: '/refugees/1/extra_contributions/1/edit').to be_routable
    end

    it 'routes to #create' do
      expect(post: '/refugees/1/extra_contributions').to be_routable
    end

    it 'routes to #update via PUT' do
      expect(put: '/refugees/1/extra_contributions/1').to be_routable
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/refugees/1/extra_contributions/1').to be_routable
    end

    it 'routes to #destroy' do
      expect(delete: '/refugees/1/extra_contributions/1').to be_routable
    end
  end
end
