require 'rails_helper'

RSpec.describe User, type: :model do
  context 'factory' do
    it 'creates a User' do
      expect(create(:user)).to be_a(User)
    end

    it 'creates an admin' do
      expect(create(:admin)).to be_a(User)
    end
  end

  context 'initialization' do
    it 'creates a User' do
      expect(User.new).to be_a(User)
    end

    it 'can be an admin' do
      expect(build(:user, admin: true)).to be_a(User)
    end
  end

  context 'validations:' do
    it 'is valid' do
      expect(build(:user)).to be_valid
    end

    it 'is invalid without a email' do
      expect(build(:user, email: nil)).not_to be_valid
    end

    it 'is invalid without a password' do
      expect(build(:user, password: nil)).not_to be_valid
    end

    it 'is invalid without a username' do
      expect(build(:user, username: nil)).not_to be_valid
    end

    it 'must have a unique username' do
      user = create(:user)
      expect(build(:user, username: user.username)).not_to be_valid
    end

    it 'is not valid with username "all"' do
      User.excluded_names = ["boz"]
      expect(build(:user, username: "boz")).not_to be_valid
    end
  end

  context 'password_complexity' do
    it 'validates "abcd123-" ' do
      user = User.new password: "abcd123-"
      user.valid?
      expect(user.errors).not_to include(:password)
    end

    it 'does not validate "abcd1234"' do
      user = User.new password: "abcd1234"
      user.valid?
      expect(user.errors).to be_added(:password, 'complexity requirement not met')
    end

    it 'does not validate "%$#@@$%)(*-+="' do
      user = User.new password: "%$#@@$%)(*-+="
      user.valid?
      expect(user.errors).to be_added(:password, 'complexity requirement not met')
    end
  end

  context 'password length' do
    it 'does not validate "abcd123"' do
      user = User.new password: 'abcd123'
      user.valid?
      expect(user.errors).to be_added(:password, 'is too short (minimum is 8 characters)')
    end
  end
end
