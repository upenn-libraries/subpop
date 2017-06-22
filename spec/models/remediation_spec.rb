require 'rails_helper'

RSpec.describe Remediation, type: :model do
  let(:subject) {  create(:remediation) }
  let(:valid_attributes) {
    {
      spreadsheet: open("#{Rails.root}/spec/fixtures/spreadsheets/Valid_Flickr_sheet.xlsx")
    }
  }

  let(:nonprovenance_item) {
    {
      column: 'C',
      image_url: 'image.url',
      not_provenance: 'x',
      evidence_format: ''
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
      column:                           "MB",
      flick_url:                        "https://www.flickr.com/photos/58558794@N07/6106275763",
      copy_current_repository:          "Penn",
      copy_call_number_shelf_mark:      "AC8 H3188 A825y",
      copy_title:                       "Youth's keepsake : A Christmas and New Year's gift for young people.",
      evidence_format:                  "Bookplate/Label",

    }
  }

  # let(:evidence_date_start_invalid) {
  #   {
  #     column:                           "C",
  #     flick_url:                        "https://www.flickr.com/photos/58558794@N07/6106275763",
  #     url_to_catalog:                   "http://franklin.library.upenn.edu/record.html?id=FRANKLIN_5050597",
  #     copy_current_repository:          "Penn Libraries",
  #     copy_current_collection:          "American Culture Class Collection",
  #     copy_current_geographic_location: "Philadelphia",
  #     copy_call_number_shelf_mark:      "AC8 H3188 A825y",
  #     copy_title:                       "Youth's keepsake : A Christmas and New Year's gift for young people.",
  #     copy_place_of_publication:        "United States Massachusetts Boston.",
  #     copy_date_of_publication:         "1835",
  #     evidence_format:                  "Bookplate/Label",
  #     evidence_comments:                "Bookplate of Carroll Atwood Wilson (1886-1947), American lawyer (he served as chief legal counsel to the Guggenheims) and book collector.",
  #     evidence_date_start:              "c. 1920s",
  #     id_owner:                         "Doug"
  #   }
  # }

 ##############################################

  let(:all_required_fields) {
    {
      column:                      'RQ',
      flick_url:                   'flickr.url',
      copy_current_repository:     'Required Repositories',
      copy_title:                  'required title',
      copy_call_number_shelf_mark: 'required0.1 number2',
      evidence_format:             'Inscription'
    }
  }

 let(:missing_required_fields) {
    {
      column:                      'MQ',
      flick_url:                   'flickr.url',
      copy_current_repository:     '',
      copy_title:                  '',
      copy_call_number_shelf_mark: '',
      evidence_format:             'Inscription',
      copy_place_of_publication:   'no place',
      evidence_comments:           'no_comment'
    }
  }

  let(:all_good_dates) {
    {
      column:                    'AD',
      flick_url:                 'flickr.url',
      copy_date_of_publication:  '1111',
      evidence_date_start:       '1112',
      evidence_date_end:         '1113',
      evidence_date:             '1114',
      evidence_format:           'Inscription'
    }
  }


  let(:all_bad_dates) {
    {
      column:                    'BD',
      flick_url:                 'flickr.url',
      copy_date_of_publication:  '8111',
      evidence_date_start:       'a112',
      evidence_date_end:         'c.1113',
      evidence_date:             '1114-3',
      evidence_format:           'Inscription'
    }
  }

   let(:bad_format_bad_content_type) {
    {
      column:                'BF',
      flick_url:             'flickr.url',
      evidence_format:       'an invalid format',
      evidence_content_type: 'an invalid content_type | Armorial'
    }
  }

   let(:good_other_format) {
    {
      column:                'GO',
      flick_url:             'flickr.url',
      evidence_format:       'Other Format',
      evidence_other_format: 'pressed flower'
    }
  }

   let(:bad_other_format) {
    {
      column:                'BO',
      flick_url:             'flickr.url',
      evidence_format:       'Other Format',
      evidence_other_format: ''
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


    it 'has no invalid headings' do
    # subject. # # # ?
    # expect(subject.problems[:headings].join).to_not include('invalid heading')
    end

    it 'has all required headings' do
    # subject. # # # ?
    # expect(subject.problems[:headings].join).to_not include('missing required')
    end



    context 'required for provenance' do
      it 'is valid if image is present'

      it 'is invalid if image is blank'

      it 'is valid if current repository is present' do
        subject.check_entry(all_required_fields)
        expect(subject.problems[:RQ].join).to_not include('copy_current_repository')
      end

      it 'is invalid if current repository is blank' do
        subject.check_entry(missing_required_fields)
        expect(subject.problems[:MQ].join).to include('copy_current_repository')
      end

      it 'is valid if call number is present' do
        subject.check_entry(all_required_fields)
        expect(subject.problems[:RQ].join).to_not include('copy_call_number_shelf_mark')
      end

      it 'is invalid if call number is blank' do
        subject.check_entry(missing_required_fields)
        expect(subject.problems[:MQ].join).to include('copy_call_number_shelf_mark')
      end

      it 'is valid if title is present' do
        subject.check_entry(all_required_fields)
        expect(subject.problems[:RQ].join).to_not include('copy_title')
      end

      it 'is invalid if title is blank' do
        subject.check_entry(missing_required_fields)
        expect(subject.problems[:MQ].join).to include('copy_title')
      end

      it 'is valid if format is other and other_format is present' do
        subject.check_entry(good_other_format)
        expect(subject.problems[:GO].join).to_not include('evidence_other_format')
      end

      it 'is invalid if format is other and other_format is blank' do
        subject.check_entry(bad_other_format)
        expect(subject.problems[:BO].join).to include('evidence_other_format')
      end
    end

    context 'field value' do
      it 'is valid if format is in the format list' do
        valid_formats = [
          "Binding",
          "Binding Waste",
          "Bookplate/Label",
          "Drawing/Illumination",
          "Inscription",
          "Other paste-in",
          "Seal",
          "Stamp -- inked",
          "Stamp -- blind or embossed",
          "Stamp -- perforated",
          "Other Format",
          "Title Page (non-evidence)",
          "Context Image (non-evidence"
        ]
        single_field_hashes = valid_formats.map{ |fmt| {column: 'A', flick_url: 'flickr.url', evidence_format: fmt} }
        single_field_hashes.each{ |h| subject.check_entry(h) }
        expect(subject.problems[:A].join).to_not include('evidence_format')
      end

      it 'is invalid if format is not in the format list' do
        subject.check_entry(bad_format_bad_content_type)
        expect(subject.problems[:BF].join).to include('evidence_format')
      end

      it 'is valid if all content types are in the content type list' do
        valid_content_types = [
          "Armorial",
          "Bibliographic Note",
          "Binder's Mark",
          "(De)Accession Mark",
          "Effaced",
          "Forgery/Copy",
          "Gift",
          "Monogram",
          "Price/Purchase Information",
          "Sale Record",
          "Shelf Mark",
          "Seller's Mark",
          "Signature"
        ]
        single_field_hashes = valid_content_types.map{ |c_t| {column: 'A', evidence_format: 'Inscription', evidence_content_type: c_t} }
        single_field_hashes.each{ |h| subject.check_entry(h) }
        subject.check_entry({column: 'A', flick_url: 'flickr.url', evidence_format: 'Inscription', evidence_content_type: 'Armorial | Gift | Monogram'})
        expect(subject.problems[:A].join).to_not include('evidence_content_type')
      end

      it 'is invalid if not all content types are in the content type list' do
        subject.check_entry(bad_format_bad_content_type)
        expect(subject.problems[:BF].join).to include('evidence_content_type')
      end

      it 'is valid if date of publication is an integer year' do
        subject.check_entry(all_good_dates)
        expect(subject.problems[:AD].join).to_not include('copy_date_of_publication')
      end

      it 'is valid if evidence: date start is an integer year' do
        subject.check_entry(all_good_dates)
        expect(subject.problems[:AD].join).to_not include('evidence_date_start')
      end

      it 'is valid if evidence: date end is an integer year' do
        subject.check_entry(all_good_dates)
        expect(subject.problems[:AD].join).to_not include('evidence_date_end')
      end

      it 'is valid if evidence: date is an integer year' do
        subject.check_entry(all_good_dates)
        expect(subject.problems[:AD].join).to_not include('evidence_date]')
      end

      it 'is invalid if date of publication is not a valid year' do
        subject.check_entry(all_bad_dates)
        expect(subject.problems[:BD].join).to include('copy_date_of_publication')
      end

      it 'is invalid if evidence: date start is not a valid year' do
        subject.check_entry(all_bad_dates)
        expect(subject.problems[:BD].join).to include('evidence_date_start')
      end

      it 'is invalid if evidence: date end is not a valid year' do
        subject.check_entry(all_bad_dates)
        expect(subject.problems[:BD].join).to include('evidence_date_end')
      end

      it 'is invalid if evidence: date is not a valid year' do
        subject.check_entry(all_bad_dates)
        expect(subject.problems[:BD].join).to include('evidence_date]')
      end

      it 'is valid if date of publication is blank' do
        subject.check_entry(minimal_bookplate)
        expect(subject.problems[:MB].join).to_not include('copy_date_of_publication')
      end

      it 'is valid if evidence: date start is blank' do
        subject.check_entry(minimal_bookplate)
        expect(subject.problems[:MB].join).to_not include('evidence_date_start')
      end

      it 'is valid if evidence: date end is blank' do
        subject.check_entry(minimal_bookplate)
        expect(subject.problems[:MB].join).to_not include('evidence_date_end')
      end

      it 'is valid if evidence: date is blank' do
        subject.check_entry(minimal_bookplate)
        expect(subject.problems[:MB].join).to_not include('evidence_date]')
      end
    end

    context 'images' do
      it 'is valid if flick_url is live'

      it 'is invalid if flick_url is not live'

      it 'is valid if image file can be found on OPenn'

      it 'is invalid if image file cannot be found on OPenn'
    end
  end
  context 'spreadsheet extractor' do
    it_behaves_like 'spreadsheet_extractor'
  end
end
