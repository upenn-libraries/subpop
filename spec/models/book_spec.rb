require 'rails_helper'

RSpec.describe Book, type: :model do
  context 'factories' do
    it 'has a factory' do
      expect(create(:book)).to be_a Book
    end

    it 'creates a complete book' do
      expect(create(:complete_book)).to be_a Book
    end
  end
end
