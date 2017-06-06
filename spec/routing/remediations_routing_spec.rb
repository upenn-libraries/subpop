require "rails_helper"

RSpec.describe RemediationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/remediations").to route_to("remediations#index")
    end

    it "routes to #new" do
      expect(:get => "/remediations/new").to route_to("remediations#new")
    end

    it "routes to #show" do
      expect(:get => "/remediations/1").to route_to("remediations#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/remediations").to route_to("remediations#create")
    end

  end
end
