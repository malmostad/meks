require "rails_helper"

RSpec.describe RefugeesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/refugees").to route_to("refugees#index")
    end

    it "routes to #new" do
      expect(:get => "/refugees/new").to route_to("refugees#new")
    end

    it "routes to #show" do
      expect(:get => "/refugees/1").to route_to("refugees#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/refugees/1/edit").to route_to("refugees#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/refugees").to route_to("refugees#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/refugees/1").to route_to("refugees#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/refugees/1").to route_to("refugees#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/refugees/1").to route_to("refugees#destroy", :id => "1")
    end

  end
end
