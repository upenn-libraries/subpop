require 'rails_helper'

RSpec.describe User, type: :model do
  context 'factory' do
    it 'creates a User' do
      expect(create(:user)).to be_a(User)
    end
  end

  context 'initialization' do
    it 'creates a User' do
      expect(User.new).to be_a(User)
    end
  end

  context 'validations:' do
    it 'is valid' do
      expect(build(:user)).to be_valid
    end

    it 'is invalid without a email' do
      expect(build(:user, email: nil)).not_to be_valid
    end

    it 'is invalid without an password' do
      expect(build(:user, password: nil)).not_to be_valid
    end

  end
end
