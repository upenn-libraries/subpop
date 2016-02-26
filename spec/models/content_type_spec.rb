require 'rails_helper'

RSpec.describe ContentType, type: :model do
  subject(:subject) { ContentType.create! }

  context 'initialize' do
    it 'creates a ContentType' do
      expect(subject).to be_a ContentType
    end
  end
end
