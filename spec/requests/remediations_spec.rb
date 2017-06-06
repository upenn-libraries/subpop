require 'rails_helper'

RSpec.describe "Remediations", type: :request do
  describe "GET /remediations" do
    it "works! (now write some real specs)" do
      get remediations_path
      expect(response).to have_http_status(200)
    end
  end
end
