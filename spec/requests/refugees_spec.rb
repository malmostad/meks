RSpec.describe "Refugees", type: :request do
  describe "GET /refugees" do
    it "should redirect to login page" do
      get refugees_path
      expect(response).to have_http_status(302)
      follow_redirect!

      expect(response).to have_http_status(200)
      expect(response).to render_template(:new)
      expect(response.body).to include("Logga in till MEKS")
    end
  end
end
