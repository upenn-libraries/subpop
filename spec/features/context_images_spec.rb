require 'rails_helper'

RSpec.feature 'Context images', type: :feature, js: true do
  scenario 'user selects a context image' do
    create_evidence_by 'testuser'
    login_as 'testuser'

    visit_evidence

    expect(page).to have_content 'Page image'
    click_link 'Link to page image'
    expect(page).to have_content 'Choose page image'
    choose 'Use image'
    click_button 'Select context image'
    expect(page).to have_button 'Remove link to page image'
  end

  scenario 'user removes a context image', type: :feature, js: true do
    create_evidence_by 'testuser'
    add_context_image_to_evidence_by 'testuser'
    login_as 'testuser'

    visit_evidence
    expect(page).to have_button 'Remove link to page image'
    click_button 'Remove link to page image'
    expect(page).to have_link 'Link to page image'
    expect(page).not_to have_button 'Remove link to page image'
  end

  scenario 'user crops a new evidence', type: :feature, js: true do
    create_book_with_photo_by 'testuser'
    login_as 'testuser'
    visit_new_bookplate

    expect(page).not_to have_content 'Page image'
    click_link 'Edit photo'
    expect(page).to have_button 'Crop image'
    click_button 'Crop image'
    expect(page).to have_content 'Page image'
  end
end