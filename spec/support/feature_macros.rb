module FeatureMacros

  def login_as username, attributes={}
    user = add_user username, attributes
    password = attributes[:password] || 'secretpassword'

    visit '/users/sign_in'
    fill_in 'Username', with: username
    fill_in 'Password', with: password
    click_button 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end

  def add_user username, attributes={}
    User.find_by username: username or FactoryGirl.create :user, attributes.merge(username: username)
  end

  def sign_out username
    click_link username
    click_link 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
  end

  def create_name_by username, attributes={}
    user = add_user username

    attributes[:name] ||= 'Smith, John'
    Name.new(attributes).save_by user
  end
end