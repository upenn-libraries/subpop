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

    # Note the following `click_button('Crop image')` does nothing b/c the
    # `shown.bs.modal` event apparently isn't fired when using
    # poltergeist/phantomjs -- also does not work with QtWebKit/capybara-
    # webkit. Works in the browser, but not here. Se we can't test whether
    # images are edited.
    #
    # I've tried a number of recommended solutions, including removing the
    # '.fade' class from the modal, using jQuery.noConflict() (in case jQuery
    # was being called twice), moving .modal('show') into the callback that
    # loads the partial (which causes `shown.bs.modal` to be fired twice, so
    # it couldn't have been left that way had it worked, which it didn't),
    # building a Santeria altar, giving the screen a stern looking at,
    # rearranging the JavaScript in different ways, waiting 20 seconds for the
    # event to occur, using the Thoughtbot wait_for_ajax hack. All to no
    # avail. I give up (for now).
    #
    # Should be changed, of course, if the problem can be solved.
    #
    # click_button('Crop image')
    click_button '×'
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

    # See note above on 'Crop image' button
    #
    # click_button('Crop image')
    click_button '×'
    expect(page).not_to have_content 'Crop image'
  end

  scenario 'User edits evidence photo' do
    create_evidence_by 'testuser'
    login_as 'testuser'
    visit_evidence

    within '#sidebar' do
      find('a', text: 'Edit photo').trigger('click')
    end

    # See note above on 'Crop image' button
    #
    # click_button('Crop image')
    click_button '×'
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

    # See note above on 'Crop image' button
    #
    # click_button('Crop image')
    click_button '×'
    expect(page).not_to have_content 'Crop image'
  end
end