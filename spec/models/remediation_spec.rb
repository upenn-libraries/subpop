require 'rails_helper'

let(:nonprovenance_item) {
  {
    column: 'C',
    image_url: 'image.url',
    not_provenance: 'x'
  }
}

let(:valid_bookplate) {
  {
    column:                           "C",
    flick_url:                        "https://www.flickr.com/photos/58558794@N07/6106275763",
    url_to_catalog:                   "http://franklin.library.upenn.edu/record.html?id=FRANKLIN_5050597",
    copy_current_repository:          "Penn Libraries",
    copy_current_collection:          "American Culture Class Collection",
    copy_current_geographic_location: "Philadelphia",
    copy_call_number_shelf_mark:      "AC8 H3188 A825y",
    copy_title:                       "Youth's keepsake : A Christmas and New Year's gift for young people.",
    copy_place_of_publication:        "United States Massachusetts Boston.",
    copy_date_of_publication:         "1835",
    evidence_format:                  "Bookplate/Label",
    evidence_comments:                "Bookplate of Carroll Atwood Wilson (1886-1947), American lawyer (he served as chief legal counsel to the Guggenheims) and book collector.",
    id_owner:                         "Wilson, Carroll A. (Carroll Atwood), 1886-1947"
  }
}


let(:minimal_bookplate) {
  {
    column:                           "C",
    flick_url:                        "https://www.flickr.com/photos/58558794@N07/6106275763",
    copy_call_number_shelf_mark:      "AC8 H3188 A825y",
    copy_title:                       "Youth's keepsake : A Christmas and New Year's gift for young people.",
    evidence_format:                  "Bookplate/Label",
    
  }
}


let(:insufficient_bookplate) {
  {

  }
}

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

      it 'is invalid if image is blank'

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

      # it 'is valid if location-in-book is in the location-in-book list'

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

  context 'spreadsheet extractor' do
    it_behaves_like 'spreadsheet_extractor'
  end
end
