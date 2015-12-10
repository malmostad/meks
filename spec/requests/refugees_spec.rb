require 'rails_helper'

RSpec.describe "Refugees", type: :request do
  describe "GET /refugees" do
    it "works! (now write some real specs)" do
      get refugees_path
      expect(response).to have_http_status(200)
    end
  end
end
