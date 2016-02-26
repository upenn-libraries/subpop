require 'rails_helper'

RSpec.describe Name, type: :model do
  subject(:subject) { Name.new }

  context 'initialization' do
    it 'creates  new name' do
      expect(subject).to be_a Name
    end
  end
end
