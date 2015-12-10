require "rails_helper"

RSpec.describe HomeTargetGroupsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/home_target_groups").to route_to("home_target_groups#index")
    end

    it "routes to #new" do
      expect(:get => "/home_target_groups/new").to route_to("home_target_groups#new")
    end

    it "routes to #show" do
      expect(:get => "/home_target_groups/1").to route_to("home_target_groups#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/home_target_groups/1/edit").to route_to("home_target_groups#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/home_target_groups").to route_to("home_target_groups#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/home_target_groups/1").to route_to("home_target_groups#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/home_target_groups/1").to route_to("home_target_groups#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/home_target_groups/1").to route_to("home_target_groups#destroy", :id => "1")
    end

  end
end
