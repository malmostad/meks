require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  describe "GET #index" do
    it "should render the index view" do
      get :index, {}, valid_session
      expect(response).to render_template :index
    end
  end

  describe "POST" do
    context "reports" do
      it "POST #refugees creates a refugees report as an Excel file" do
        post :refugees, { }, valid_session
        expect(response).to have_http_status(200)
        expect(response['Content-Type']).to eq("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
        expect(response.body[0...2]).to eq "PK" # An xlsx is packed as a zip file
      end

      it "POST #homes creates a placements report as an Excel file" do
        post :homes, { }, valid_session
        expect(response).to have_http_status(200)
        expect(response['Content-Type']).to eq("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
        expect(response.body[0...2]).to eq "PK" # An xlsx is packed as a zip file
      end

      it "POST #placements creates a placements report as an Excel file" do
        post :placements, { placements_home_id: nil }, valid_session
        expect(response).to have_http_status(200)
        expect(response['Content-Type']).to eq("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
        expect(response.body[0...2]).to eq "PK" # An xlsx is packed as a zip file
      end
    end
  end
end
