require 'rails_helper'

RSpec.describe FlickrController, type: :controller do
  let(:evidence) { create(:evidence) }

  describe "GET #show" do
    it "returns http success" do
      get :show, { item_type: 'evidence', id: evidence.id }
      expect(response).to have_http_status(:success)
    end
  end

end
