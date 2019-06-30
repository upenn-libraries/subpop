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
      flickr_url:                        "https://www.flickr.com/photos/58558794@N07/6106275763",
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
      flickr_url:                        "https://www.flickr.com/photos/58558794@N07/6106275763",
      copy_current_repository:          "Penn",
      copy_call_number_shelf_mark:      "AC8 H3188 A825y",
      copy_title:                       "Youth's keepsake : A Christmas and New Year's gift for young people.",
      evidence_format:                  "Bookplate/Label",

    }
  }

  # let(:evidence_date_start_invalid) {
  #   {
  #     column:                           "C",
  #     flickr_url:                        "https://www.flickr.com/photos/58558794@N07/6106275763",
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
      flickr_url:                  'flickr.url',
      copy_current_repository:     'Required Repositories',
      copy_title:                  'required title',
      copy_call_number_shelf_mark: 'required0.1 number2',
      evidence_format:             'Inscription'
    }
  }

 let(:missing_required_fields) {
    {
      flickr_url:                  '',
      column:                      'MQ',
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
      flickr_url:                'flickr.url',
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
      flickr_url:                'flickr.url',
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
      flickr_url:             'flickr.url',
      evidence_format:       'an invalid format',
      evidence_content_type: 'an invalid content_type | Armorial'
    }
  }

   let(:good_other_format) {
    {
      column:                'GO',
      flickr_url:            'flickr.url',
      evidence_format:       'Other Format',
      evidence_other_format: 'pressed flower'
    }
  }

   let(:bad_other_format) {
    {
      column:                'BO',
      flickr_url:            'flickr.url',
      evidence_format:       'Other Format',
      evidence_other_format: ''
    }
  }


  let(:good_flickr_photo) {
    {
      column:    'FP',
      flickr_url: 'https://www.flickr.com/photos/58558794@N07/6106275763',
      format:    'Inscription'
    }
  }

  let(:good_openn_photo) {
    {
      column:   'OP',
      format:    'Inscription'
    }
  }

  let(:non_url) {
    {
      column:    'NU',
      flickr_url: 'not a url at all',
      format:    'Inscription'
    }
  }

  let(:bad_flickr_url) {
    {
      column:    'BF',
      flickr_url: '',
      format:    'Inscription'
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

    it 'is valid if it has no invalid headings' do
      remediation = create :remediation
      remediation.verify_headings
      expect(remediation).to be_problem_free
    end

    it 'is invalid if it has invalid headings' do

    end


    context 'required for provenance' do
      # it 'is valid if image is present' do

      # end

      it 'is invalid if image field is blank' do
        subject.check_entry(missing_required_fields)
        expect(subject.fetch_problem(:MQ).join).to include('flickr_url')
      end

      it 'is valid if current repository is present' do
        subject.check_entry(all_required_fields)
        expect(subject.fetch_problem(:RQ).join).to_not include('copy_current_repository')
      end

      it 'is invalid if current repository is blank' do
        subject.check_entry(missing_required_fields)
        expect(subject.fetch_problem(:MQ).join).to include('copy_current_repository')
      end

      it 'is valid if call number is present' do
        subject.check_entry(all_required_fields)
        expect(subject.fetch_problem(:RQ).join).to_not include('copy_call_number_shelf_mark')
      end

      it 'is invalid if call number is blank' do
        subject.check_entry(missing_required_fields)
        expect(subject.fetch_problem(:MQ).join).to include('copy_call_number_shelf_mark')
      end

      it 'is valid if title is present' do
        subject.check_entry(all_required_fields)
        expect(subject.fetch_problem(:RQ).join).to_not include('copy_title')
      end

      it 'is invalid if title is blank' do
        subject.check_entry(missing_required_fields)
        expect(subject.fetch_problem(:MQ).join).to include('copy_title')
      end

      it 'is valid if format is other and other_format is present' do
        subject.check_entry(good_other_format)
        expect(subject.fetch_problem(:GO).join).to_not include('evidence_other_format')
      end

      it 'is invalid if format is other and other_format is blank' do
        subject.check_entry(bad_other_format)
        expect(subject.fetch_problem(:BO).join).to include('evidence_other_format')
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
          "Wax Seal",
          "Stamp -- inked",
          "Stamp -- blind or embossed",
          "Stamp -- perforated",
          "Other Format",
          "Title Page (non-evidence)",
          "Context Image (non-evidence"
        ]
        valid_formats.each do |fmt|
          remediation = Remediation.new
          remediation.check_format fmt
          expect(remediation).to be_problem_free
        end
      end

      it 'is invalid if format is not in the format list' do
        subject.check_entry(bad_format_bad_content_type)
        expect(subject.fetch_problem(:BF).join).to include('evidence_format')
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
        valid_content_types.each { |n| ContentType.find_or_create_by name: n }
        valid_content_types.each do |content_type|
          remediation = Remediation.new
          expect(remediation.valid_content_type? content_type).to be_truthy, "exepected #{content_type} to be valid"
        end
      end

      it 'is invalid if not all content types are in the content type list' do
        subject.check_entry(bad_format_bad_content_type)
        expect(subject.fetch_problem(:BF).join).to include('evidence_content_type')
      end

      it 'is valid if date of publication is an integer year' do
        subject.check_entry(all_good_dates)
        expect(subject.fetch_problem(:AD).join).to_not include('copy_date_of_publication')
      end

      it 'is valid if evidence: date start is an integer year' do
        subject.check_entry(all_good_dates)
        expect(subject.fetch_problem(:AD).join).to_not include('evidence_date_start')
      end

      it 'is valid if evidence: date end is an integer year' do
        subject.check_entry(all_good_dates)
        expect(subject.fetch_problem(:AD).join).to_not include('evidence_date_end')
      end

      it 'is valid if evidence: date is an integer year' do
        subject.check_entry(all_good_dates)
        expect(subject.fetch_problem(:AD).join).to_not include('evidence_date]')
      end

      it 'is invalid if date of publication is not a valid year' do
        subject.check_entry(all_bad_dates)
        expect(subject.fetch_problem(:BD).join).to include('copy_date_of_publication')
      end

      it 'is invalid if evidence: date start is not a valid year' do
        subject.check_entry(all_bad_dates)
        expect(subject.fetch_problem(:BD).join).to include('evidence_date_start')
      end

      it 'is invalid if evidence: date end is not a valid year' do
        subject.check_entry(all_bad_dates)
        expect(subject.fetch_problem(:BD).join).to include('evidence_date_end')
      end

      it 'is invalid if evidence: date is not a valid year' do
        subject.check_entry(all_bad_dates)
        expect(subject.fetch_problem(:BD).join).to include('evidence_date]')
      end

      it 'is valid if date of publication is blank' do
        subject.check_entry(minimal_bookplate)
        expect(subject.fetch_problem(:MB).join).to_not include('copy_date_of_publication')
      end

      it 'is valid if evidence: date start is blank' do
        subject.check_entry(minimal_bookplate)
        expect(subject.fetch_problem(:MB).join).to_not include('evidence_date_start')
      end

      it 'is valid if evidence: date end is blank' do
        subject.check_entry(minimal_bookplate)
        expect(subject.fetch_problem(:MB).join).to_not include('evidence_date_end')
      end

      it 'is valid if evidence: date is blank' do
        subject.check_entry(minimal_bookplate)
        expect(subject.fetch_problem(:MB).join).to_not include('evidence_date]')
      end
    end

    context 'images' do
      it 'is valid if flickr_url is live' do
        subject.check_entry(good_flickr_photo)
        expect(subject.fetch_problem(:FP).join).to_not include('flickr_url')
      end

      it 'is invalid if flickr_url is not live'

      it 'is valid if image file can be found on OPenn'

      it 'is invalid if image file cannot be found on OPenn'
    end
  end
  context 'spreadsheet extractor' do
    it_behaves_like 'spreadsheet_extractor'
  end
end
