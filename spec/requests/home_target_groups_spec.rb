require 'rails_helper'

RSpec.describe "HomeTargetGroups", type: :request do
  describe "GET /home_target_groups" do
    it "works! (now write some real specs)" do
      get home_target_groups_path
      expect(response).to have_http_status(200)
    end
  end
end
