require 'rails_helper'

RSpec.describe Remediation, type: :model do
  let(:subject) {  create(:remediation) }
  let(:valid_attributes) {
    {
      spreadsheet: open("#{Rails.root}/spec/fixtures/spreadsheets/Valid_Flickr_sheet.xlsx")
    }
  }
  context 'factory' do
    it 'creates a Remediation' do
      expect(create :remediation).to be_a Remediation
    end
  end

  context 'initialize' do
    it 'builds a Remediation' do
      expect(Remediation.new).to be_a Remediation
    end

    it 'builds a valid remediation' do
      expect(Remediation.new valid_attributes).to be_valid
    end

    it 'creates a Remediation' do
      expect(Remediation.create! valid_attributes).to be_a Remediation
    end
  end

  context 'validates' do
    it 'is not valid without a spreadsheet' do
      remediation = Remediation.new
      remediation.valid?
      expect(remediation.errors[:spreadsheet]).to be_present
    end

    it 'is valid with a spreadsheet' do
      remediation = Remediation.new spreadsheet: open("#{Rails.root}/spec/fixtures/spreadsheets/Valid_Flickr_sheet.xlsx")
      remediation.valid?
      expect(remediation.errors[:spreadsheet]).not_to be_present
    end
  end
end
