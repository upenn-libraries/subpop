module FeatureMacros
  def login_as username, admin=false
    user = FactoryGirl.create(:user,
      username: username,
      password: 'secretpassword',
      password_confirmation: 'secretpassword')

      visit '/users/sign_in'
      fill_in 'Username', with: username
      fill_in 'Password', with: 'secretpassword'
      click_button 'Log in'
      expect(page).to have_content 'Signed in successfully.'
  end
end