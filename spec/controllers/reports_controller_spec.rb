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
      it "POST #generate creates a new queued job" do
        expect {
          post :generate, { report_type: 'refugees' }, valid_session
        }.to change(Delayed::Job, :count).by(1)
      end
    end
  end
end
