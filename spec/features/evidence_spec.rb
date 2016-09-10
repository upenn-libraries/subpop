require 'rails_helper'

RSpec.feature "Evidence", type: :feature, js: true do

  scenario 'User previews evidence' do
    create_evidence_by 'testuser'
    login_as 'testuser'
    visit_evidence

    find("a[data-modal-id=preview-modal]").trigger 'click'
    expect(page).to have_css 'h1', text: 'Title'
    expect(page).to have_css 'h1', text: 'Tags'
  end
end