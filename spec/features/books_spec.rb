require 'rails_helper'

RSpec.feature "Books", type: :feature, js: true do
  feature 'User creates a book' do
    scenario 'enters a new book with evidence' do
      # create a book with an images
      visit '/books/new'
      fill_in 'Current repository', with: 'Penn Libraries'
      fill_in 'Call number / Shelf mark', with: 'BK 123'
      fill_in 'Title', with: 'Holy Bible'
      fill_in 'Publisher / Printer / Scribe', with: 'Aitken'
      attach_file 'image_', "#{Rails.root}/spec/fixtures/images/BS_185_178207.jpg"
      click_button 'Create Book'
      expect(page).to have_content 'Book was successfully created.'
      expect(page).to have_content '1 photos'
      expect(page).to have_css '.field-value', text: 'Penn Libraries'
      expect(page).to have_select 'use', selected: 'Use image for'

      # Use the image for a bookplate
      select 'Bookplate/Label'
      expect(page).to have_content 'New Bookplate/Label'
      click_button 'Create Evidence'

      # Confirm the page exists
      expect(page).to have_content 'Evidence was successfully created.'
      expect(page).to have_content 'Publish image'

      # return to the book page
      click_link 'Book'
      expect(page).to have_content 'Publish image'
      expect(page).to have_content 'Publish book'

      # look at the details
      click_link 'Details'
      expect(page).to have_content 'Bookplate/Label'
    end

    scenario 'user selects a title page' do
       visit '/books/new'
      fill_in 'Current repository', with: 'Penn Libraries'
      fill_in 'Call number / Shelf mark', with: 'BK 123'
      fill_in 'Title', with: 'Holy Bible'
      fill_in 'Publisher / Printer / Scribe', with: 'Aitken'
      attach_file 'image_', "#{Rails.root}/spec/fixtures/images/BS_185_178207.jpg"
      click_button 'Create Book'
      expect(page).to have_content 'Book was successfully created.'
      expect(page).to have_content '1 photos'
      expect(page).to have_css '.field-value', text: 'Penn Libraries'
      expect(page).to have_select 'use', selected: 'Use image for'

      # Use the image for a bookplate
      select 'Title page'
      expect(page).to have_content 'Remove title page'
    end
  end
end
