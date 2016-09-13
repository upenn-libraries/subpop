require 'rails_helper'

RSpec.feature "Cropping", type: :feature, js: true do

  scenario 'User crops book photo' do
    create_book_with_photo_by 'testuser'
    login_as 'testuser'
    visit_book

    expect(page).to have_content "Who has it?"
    expect(page).to have_content "1 photos"
    click_link 'Edit photo'
    expect(page).to have_content 'Crop image'

    click_button('Crop image')
    expect(page).not_to have_content 'Crop image'
  end

  scenario 'User edits title page photo' do
    create_book_with_photo_by 'testuser'
    make_photo_a_title_page

    login_as 'testuser'
    visit_book
    expect(page).to have_content 'Remove title page'
    within '#sidebar' do
      find('a', text: 'Edit photo').trigger('click')
    end

    click_button('Crop image')
    expect(page).not_to have_content 'Crop image'
  end

  scenario 'User edits a title page twice' do
    create_book_with_photo_by 'testuser'
    make_photo_a_title_page

    login_as 'testuser'
    visit_book
    expect(page).to have_content 'Remove title page'

    # edit first time
    within '#sidebar' do
      find('a', text: 'Edit photo').trigger('click')
    end
    find("button[title='Rotate Right']").click
    click_button('Crop image')
    expect(page).not_to have_content 'Crop image'

    # edit second time
    within '#sidebar' do
      find('a', text: 'Edit photo').trigger('click')
    end
    find("button[title='Rotate Right']").click
    click_button('Crop image')
    expect(page).not_to have_content 'Crop image'
  end

  scenario 'User edits evidence photo' do
    create_evidence_by 'testuser'
    login_as 'testuser'
    visit_evidence

    within '#sidebar' do
      find('a', text: 'Edit photo').trigger('click')
    end

    click_button('Crop image')
    expect(page).not_to have_content 'Crop image'
  end

  scenario 'User edits new evidence photo' do
    create_book_with_photo_by 'testuser'
    login_as 'testuser'
    visit_book

    expect(page).to have_select 'use', selected: 'Use image for'
    select 'Bookplate/Label'
    expect(page).to have_content 'New Bookplate/Label'

    within '#sidebar' do
      find('a', text: 'Edit photo').trigger('click')
    end

    click_button('Crop image')
    expect(page).not_to have_content 'Crop image'
  end
end