require "rails_helper"

RSpec.describe HomeTypesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/home_types").to route_to("home_types#index")
    end

    it "routes to #new" do
      expect(:get => "/home_types/new").to route_to("home_types#new")
    end

    it "routes to #show" do
      expect(:get => "/home_types/1").to route_to("home_types#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/home_types/1/edit").to route_to("home_types#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/home_types").to route_to("home_types#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/home_types/1").to route_to("home_types#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/home_types/1").to route_to("home_types#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/home_types/1").to route_to("home_types#destroy", :id => "1")
    end

  end
end
