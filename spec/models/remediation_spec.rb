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

  context 'problems' do
    it 'saves problems' do
      rem = create :remediation, problems: %w(error1 error2)
      rem.reload
      expect(rem.problems).to eq(%w(error1 error2))
    end
  end

  context 'spreadsheet_checker' do
    it 'says the sheet is problem free' do
      expect(create :remediation).to be_problem_free
    end

    it 'has required headings'

    it 'is valid if non-provenance is true and format is blank'

    it 'is invalid if non-provenance is true and format is not blank'

    context 'required for provenance' do
      it 'is valid if image is present'

      it 'is invalid if imagine is blank'

      it 'is valid if current repository is present'

      it 'is invalid if current repository is blank'

      it 'is valid if call number is present'

      it 'is invalid if call number is blank'

      it 'is valid if title is present'

      it 'is invalid if title is blank'

      it 'is valid if format is other and format_other is present'

      it 'is invalid if format is other and format_other is blank'
    end

    context 'field value' do
      it 'is valid if format is in the format list'

      it 'is invalid if format is not in the format list'

      it 'is valid if location-in-book is in the location-in-book list'

      it 'is invalid if location-in-book is not in the location-in-book list'

      it 'is valid if content type is in the content type list'

      it 'is invalid if content type is not in the content type list'

      # for 'piped' entries
      it 'is valid if all content types are in the content type list' 
      
      it 'is invalid if not all content types are in the content type list' 
      # ------------------

      it 'is valid if date of publication is an integer year'

      it 'is valid if evidence: date start is an integer year'
      
      it 'is valid if evidence: date end is an integer year'

      it 'is valid if evidence: date is an integer year'

      it 'is invalid if date of publication is not a valid year'

      it 'is invalid if evidence: date start is not a valid year'
      
      it 'is invalid if evidence: date end is not a valid year'

      it 'is invalid if evidence: date is not a valid year'

      it 'is valid if date of publication is blank'

      it 'is valid if evidence: date start is blank'
      
      it 'is valid if evidence: date end is blank'

      it 'is valid if evidence: date is blank'
    end

    context 'images' do
      it 'is valid if flick_url is live'

      it 'is invalid if flick_url is not live'

      it 'is valid if image file can be found on OPenn'

      it 'is invalid if image file cannot be found on OPenn'
    end

  end
end
