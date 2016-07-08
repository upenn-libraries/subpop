require 'rails_helper'

RSpec.feature "Registrations", type: :feature, js: true do
  scenario 'user edits full name and email' do
    login_as 'testuser'

    click_link 'testuser'
    click_link 'Manage account'
    fill_in 'Full name',        with: 'CeeLo Green'
    fill_in 'Email',            with: 'ceelo@example.com'
    fill_in 'Current password', with: 'secretpassword'
    click_button 'Update'
    expect(page).to have_content 'Your account has been updated successfully.'

    # check that the value was changed
    click_link 'testuser'
    click_link 'Manage account'
    expect(page).to have_field 'Full name', with: 'CeeLo Green'
    expect(page).to have_field 'Email',     with: 'ceelo@example.com'
  end

  scenario 'user edits password' do
    login_as 'testuser'

    click_link 'testuser'
    click_link 'Manage account'
    fill_in 'Password',               with: 'abcd1234'
    fill_in 'Password confirmation',  with: 'abcd1234'
    fill_in 'Current password',       with: 'secretpassword'
    click_button 'Update'
    expect(page).to have_content 'Your account has been updated successfully.'

    # log out and then log in with the new password
    click_link 'testuser'
    click_link 'Sign out'
    click_link 'Sign in'
    fill_in 'Username', with: 'testuser'
    fill_in 'Password', with: 'abcd1234'
    click_button 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'user cancels account' do
    login_as 'testuser'

    click_link 'testuser'
    click_link 'Manage account'
    click_button 'Cancel my account'
    expect(page).to have_content 'Bye! Your account has been successfully cancelled.'

    # try to log in
    click_link 'Sign in'
    fill_in 'Username', with: 'testuser'
    fill_in 'Password', with: 'secretpassword'
    click_button 'Log in'
    expect(page).to have_content 'Sorry, your account has been cancelled.'
  end
end
