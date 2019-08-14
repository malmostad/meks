RSpec.describe SamlController, type: :routing do
  describe 'routing' do
    it 'routes to #sso' do
      expect(get: '/saml/sso').to route_to('saml#sso')
    end

    it 'routes to #consume' do
      expect(post: '/saml/consume').to route_to('saml#consume')
    end

    it 'routes to #metadata' do
      expect(get: '/saml/metadata').to route_to('saml#metadata')
    end

    it 'routes to #logout' do
      expect(get: '/saml/logout').to route_to('saml#logout')
    end
  end
end
