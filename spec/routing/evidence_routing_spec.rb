require "rails_helper"

RSpec.describe EvidenceController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/evidence").to route_to("evidence#index")
    end

    it "routes to #new" do
      expect(:get => "/evidence/new").to route_to("evidence#new")
    end

    it "routes to #show" do
      expect(:get => "/evidence/1").to route_to("evidence#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/evidence/1/edit").to route_to("evidence#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/evidence").to route_to("evidence#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/evidence/1").to route_to("evidence#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/evidence/1").to route_to("evidence#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/evidence/1").to route_to("evidence#destroy", :id => "1")
    end

  end
end
