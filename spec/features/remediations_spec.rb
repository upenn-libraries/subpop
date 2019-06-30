require 'rails_helper'

RSpec.feature "Remediations", type: :feature, js: false do
  scenario 'Non-authorized user tries to visit remediations page' do
    login_as 'testuser'
    visit '/remediations'
    expect(page).to have_content 'Not authorized to index remediation'

  end

  scenario 'User creates a remediation' do
    login_as "testuser", admin: true
    visit '/remediations'

    click_link 'New Remediation'

    attach_file 'Spreadsheet', "#{Rails.root}/spec/fixtures/spreadsheets/Valid_Flickr_sheet.xlsx"

    click_button 'Upload'

    expect(page).to have_content 'Remediation was successfully created'
  end

  scenario 'User visits a list of remediations' do
    add_user 'testuser', admin: true
    create_remediation_by 'testuser'

    login_as 'testuser'
    visit '/remediations'
    expect(page).to have_content 'Valid_Flickr_sheet.xlsx'
    click_link 'Details'
    expect(page).to have_content 'Valid_Flickr_sheet.xlsx'
  end
end
