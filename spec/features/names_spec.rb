require 'rails_helper'

RSpec.feature "Names", type: :feature do
  scenario 'user creates name' do
    login_as 'testuser'

    click_link 'Names'
    click_link 'New Name'
    fill_in 'Name',             with: 'Revere, Paul'
    fill_in 'Year start',       with: 1735
    fill_in 'Year end',         with: 1818
    fill_in 'VIAF identifier',  with: '59880275'
    fill_in 'Comment',          with: 'The text of the comment.'

    click_button 'Create Name'

    expect(page).to have_content 'Name was successfully created.'
    expect(page).to have_content 'Revere, Paul'
    expect(page).to have_content '1735'
    expect(page).to have_content '1818'
    expect(page).to have_content '59880275'
    expect(page).to have_content 'The text of the comment.'
  end

  scenario 'user updates name' do
    create_name_by 'testuser', { name: 'Revere, Paul' }
    login_as 'testuser'

    # update the name
    click_link 'Names'
    find('tr', text: 'Revere, Paul').click_link 'Edit'
    # make sure the fields are empty
    expect(page).to have_field 'Name',            with: 'Revere, Paul'
    expect(find_field('Year start').value).to       be_blank
    expect(find_field('Year end').value).to         be_blank
    expect(find_field('VIAF identifier').value).to  be_blank
    expect(find_field('Comment').value).to          be_blank
    # fill in stuff
    fill_in 'Year start',      with: 1735
    fill_in 'Year end',        with: 1818
    fill_in 'VIAF identifier', with: '59880275'
    fill_in 'Comment',         with: 'The text of the comment.'
    click_button 'Update Name'

    # confirm changes
    expect(page).to have_content 'Name was successfully updated.'
    expect(page).to have_content 'Revere, Paul'
    expect(page).to have_content '1735'
    expect(page).to have_content '1818'
    expect(page).to have_content '59880275'
    expect(page).to have_content 'The text of the comment.'
  end
end
