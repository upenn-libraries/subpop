require 'rails_helper'

RSpec.describe "Evidence", type: :request do
  subject(:subject) { create(:evidence) }

  describe "GET /evidence" do
    it "works! (now write some real specs)" do
      get @evidence
      expect(response).to have_http_status(200)
    end
  end
end
