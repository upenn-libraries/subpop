require 'rails_helper'

RSpec.describe TitlePagesController, type: :controller do
  login_admin
  let(:title_page) { create(:title_page) }

  describe "GET #show" do
    it "returns http success" do
      get :show, { id: title_page }
      expect(response).to have_http_status(:redirect)
    end
  end

end
