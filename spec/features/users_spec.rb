require 'rails_helper'

RSpec.feature "Users", type: :feature, js: true do
  scenario 'admin creates user' do
    login_as 'admin', admin: true

    # go to the users page and create a new user
    click_link 'Users'
    click_link 'New User'
    fill_in 'Full name',              with: 'MF Doom'
    fill_in 'Username',               with: 'doom'
    fill_in 'Email',                  with: 'viktorvaugn@example.com'
    fill_in 'Password',               with: 'vaudevillevillain'
    fill_in 'Password confirmation',  with: 'vaudevillevillain'
    check   'Admin'
    click_button 'Create'

    # verify user created correctly
    expect(page).to have_content "Successfully created user 'doom'."
    find('tr', text: 'doom').click_link 'Edit'
    expect(page).to have_field 'Full name',   with: 'MF Doom'
    expect(page).to have_field 'Email',       with: 'viktorvaugn@example.com'
    expect(page).to have_field 'Username',    with: 'doom'
    expect(page).to have_checked_field 'Admin'
  end

  scenario 'admin edits user' do
    add_user('doom',
      full_name: 'MF Doom',
      email: 'viktorvaugn@example.com',
      admin: true)
    login_as 'admin', admin: true

    # go to the user edit page
    click_link 'Users'
    find('tr', text: 'doom').click_link 'Edit'
    expect(page).to have_field 'Full name',   with: 'MF Doom'
    expect(page).to have_field 'Email',       with: 'viktorvaugn@example.com'
    expect(page).to have_field 'Username',    with: 'doom'
    expect(page).to have_checked_field 'Admin'

    # edit the user
    fill_in 'Full name',              with: 'Viktor Vaughn'
    fill_in 'Email',                  with: 'madvillain@example.com'
    uncheck 'Admin'
    click_button 'Update'
    expect(page).to have_content "Successfully updated user 'doom'."

    # confirm user details
    find('tr', text: 'doom').click_link('Edit')
    expect(page).to have_field 'Full name', with: 'Viktor Vaughn'
    expect(page).to have_field 'Email',     with: 'madvillain@example.com'
    expect(page).to have_field 'Username',  with: 'doom'
    expect(page).to have_unchecked_field 'Admin'
  end

  scenario 'admin cancels user' do
    add_user('doom',
      full_name: 'MF Doom',
      email: 'viktorvaugn@example.com',
      admin: false)
    login_as 'admin', admin: true

    # go to the user edit page and cancel the account
    click_link 'Users'
    find('tr', text: 'doom').click_link 'Edit'
    click_button 'Cancel account'
    expect(page).to have_content "Cancelled account 'doom'."
    click_link 'admin'
    click_link 'Sign out'

    # user tries to sign in
    click_link 'Sign in'
    fill_in 'Username', with: 'doom'
    fill_in 'Password', with: 'secretpassword'
    click_button 'Log in'
    expect(page).to have_content 'Sorry, your account has been cancelled.'
  end

  scenario "admin restores user's account" do
   add_user('doom',
    full_name: 'MF Doom',
    email: 'viktorvaugn@example.com',
    admin: false,
    deleted_at: Time.now)

   login_as 'admin', admin: true
    # go to the user edit page and restore the account
    click_link 'Users'
    find('tr', text: 'doom').click_link 'Edit'
    # Poltergeist reports 'Restore account' is overlapped by nav bar, but
    # clearly from the screen shot it is not; using trigger instead
    # click_button 'Restore account'
    find("input[value='Restore account']").trigger 'click'
    expect(page).to have_content "Successfully updated user 'doom'."
    click_link 'admin'
    click_link 'Sign out'

    # user signs in with restored account
    click_link 'Sign in'
    fill_in 'Username', with: 'doom'
    fill_in 'Password', with: 'secretpassword'
    click_button 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end
end
