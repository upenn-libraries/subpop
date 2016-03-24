require 'rails_helper'

RSpec.describe Name, type: :model do
  subject(:subject) { create(:name) }

  context 'initialization' do
    it 'creates  new name' do
      expect(subject).to be_a Name
    end
  end

  context 'validates' do
    it "is valid" do
      expect(build(:name)).to be_valid
    end

    it "isn't valid if name is blank" do
      expect(build(:name, name: nil)).not_to be_valid
    end

    it "isn't valid is name is not unique" do
      expect(build(:name, name: subject.name)).not_to be_valid
    end

    it "is valid if VIAF ID is numerical" do
      expect(build(:name, viaf_id: "123456789012345678901234567890")).to be_valid
    end

    it "is not valid if VIAF ID is not a number" do
      expect(build(:name, viaf_id: "123456789012345678901234567890x")).not_to be_valid
    end
  end
end
