require 'rails_helper'

RSpec.describe FlashController, type: :controller do

  describe "GET #show" do
    it "returns http success" do
      xhr :get, :show
      expect(response).to have_http_status(:success)
    end
  end

end
