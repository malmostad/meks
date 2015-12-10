require 'rails_helper'

RSpec.describe "HomeTypes", type: :request do
  describe "GET /home_types" do
    it "works! (now write some real specs)" do
      get home_types_path
      expect(response).to have_http_status(200)
    end
  end
end
