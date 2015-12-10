require 'rails_helper'

RSpec.describe "HomeOwnerTypes", type: :request do
  describe "GET /home_owner_types" do
    it "works! (now write some real specs)" do
      get home_owner_types_path
      expect(response).to have_http_status(200)
    end
  end
end
