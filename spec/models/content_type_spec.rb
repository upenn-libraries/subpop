require 'rails_helper'

RSpec.describe ContentType, type: :model do
  subject(:subject) { create :content_type }

  context 'initialize' do
    it 'creates a ContentType' do
      expect(subject).to be_a ContentType
    end
  end

  context 'factories' do
    it "creates a content type" do
      expect(create(:content_type)).to be_a ContentType
    end
  end

  context 'validates' do
    it "is valid" do
      expect(subject).to be_valid
    end

    it "requires a name" do
      expect(build(:content_type, name: nil)).not_to be_valid
    end

    it "requires name be unique" do
      expect(build(:content_type, name: subject.name)).not_to be_valid
    end
  end
end
