require 'rails_helper'

RSpec.describe RemediationAgent, type: :model do
  let(:subject) { create :remediation_agent }
  let(:valid_attibutes) {
    { remediation: create(:remediation) }
  }

 let(:not_provenance_hash) {
    {
      column:         'C',
      image_url:      'https://www.flickr.com/photos/130616888@N02/34478571073',
      not_provenance: 'x'
    }
  }

  let(:no_format_hash) {
    {
      column:                           "C",
      flickr_url:                       "https://www.flickr.com/photos/130616888@N02/34444669214",
      url_to_catalog:                   "http://franklin.library.upenn.edu/record.html?id=FRANKLIN_5050597",
      copy_current_repository:          "Penn Libraries",
      copy_current_collection:          "American Culture Class Collection",
      copy_current_geographic_location: "Philadelphia",
      copy_call_number_shelf_mark:      "AC8 H3188 A825y",
      copy_title:                       "Youth's keepsake : A Christmas and New Year's gift for young people.",
      copy_place_of_publication:        "United States Massachusetts Boston.",
      copy_date_of_publication:         "1835",
      evidence_comments:                "Bookplate of Carroll Atwood Wilson (1886-1947), American lawyer (he served as chief legal counsel to the Guggenheims) and book collector.",
      id_owner:                         "Wilson, Carroll A. (Carroll Atwood), 1886-1947"
    }
  }

  let(:valid_bookplate) {
    {
      column:                           "C",
      flickr_url:                       "https://www.flickr.com/photos/130616888@N02/35158508881",
      url_to_catalog:                   "http://franklin.library.upenn.edu/record.html?id=FRANKLIN_5050597",
      copy_current_repository:          "Penn Libraries",
      copy_current_collection:          "American Culture Class Collection",
      copy_current_geographic_location: "Philadelphia",
      copy_call_number_shelf_mark:      "AC8 H3188 A825y",
      copy_volume_number:               "Vol. I",
      copy_title:                       "Youth's keepsake : A Christmas and New Year's gift for young people.",
      copy_author:                      "Tom Tucker",
      copy_place_of_publication:        "United States Massachusetts Boston.",
      copy_date_of_publication:         "1835",
      copy_date_narrative:              "Early 19th C.",
      copy_printer_publisher_scribe:    "Du Breuil, Antoine.",
      copy_acquisition_source:          "Gift of x",
      evidence_format:                  "Bookplate/Label",
      evidence_comments:                "Bookplate of Carroll Atwood Wilson (1886-1947), American lawyer (he served as chief legal counsel to the Guggenheims) and book collector.",
      evidence_location_in_book:        "Inside Front Cover",
      evidence_content_type:            "Gift/Presentation | Armorial",
      evidence_translation:             "This is a translation",
      evidence_transcription:           "This is a transcription",
      evidence_date_start:              1850,
      evidence_date_end:                1870,
      evidence_place:                   "France",
      evidence_citation:                "Nice article in, like, a journal",
      id_owner:                         "Wilson, Carroll A. (Carroll Atwood), 1886-1947 | Barber, Joseph",
      id_librarian:                     "Chark, William",
      id_bookseller_auction_house:      "Stevens & Sons",
      id_binder:                        "Brian Frost & Company",
      id_annotator:                     "McScribbler, Scribbly",
      id_unknown_role:                  "Mr. Mysterioso",
      problems:                         "Trouble comin' my way."
    }
  }

  let(:bookplate_with_gender) {
    {
      column:                           "C",
      flickr_url:                       "https://www.flickr.com/photos/130616888@N02/35158508881",
      copy_call_number_shelf_mark:      "AC8 H3188 A825y",
      copy_title:                       "Youth's keepsake : A Christmas and New Year's gift for young people.",
      evidence_format:                  "Bookplate/Label",
      id_owner:                         "Wilson, Carroll A. (Carroll Atwood), 1886-1947",
      id_gender:                        "Other",
      problems:                         "Trouble comin' my way."
    }
  }

  let(:bookplate_with_gender_two_agents) {
    {
      column:                           "C",
      flickr_url:                       "https://www.flickr.com/photos/130616888@N02/35158508881",
      copy_call_number_shelf_mark:      "AC8 H3188 A825y",
      copy_title:                       "Youth's keepsake : A Christmas and New Year's gift for young people.",
      evidence_format:                  "Bookplate/Label",
      id_owner:                         "Wilson, Carroll A. (Carroll Atwood), 1886-1947",
      id_annotator:                     "Annotator, The",
      id_gender:                        "Other",
      problems:                         "Trouble comin' my way."
    }
  }

  let(:bookplate_with_gender_two_owners) {
    {
      column:                           "C",
      flickr_url:                       "https://www.flickr.com/photos/130616888@N02/35158508881",
      copy_call_number_shelf_mark:      "AC8 H3188 A825y",
      copy_title:                       "Youth's keepsake : A Christmas and New Year's gift for young people.",
      evidence_format:                  "Bookplate/Label",
      evidence_location_in_book:        "Inside Front Cover",
      id_owner:                         "Wilson, Carroll A. (Carroll Atwood), 1886-1947 |  | Barber, Joseph",
      id_gender:                        "Other",
      problems:                         "Trouble comin' my way."
    }
  }

  let(:valid_title_page) {
    {
      column:                           "E",
      flickr_url:                       "https://www.flickr.com/photos/130616888@N02/34478571073",
      url_to_catalog:                   "http://franklin.library.upenn.edu/record.html?id=FRANKLIN_5885953",
      copy_current_repository:          "Penn Libraries",
      copy_current_collection:          "French Culture Class Collection",
      copy_current_geographic_location: "Philadelphia",
      copy_call_number_shelf_mark:      "FC6 D8536 Eg672pb",
      copy_author:                      "Dubreuil, Jean, 1602-1670.",
      copy_title:                       "Perspective practical ,or , A plain and easie method of true and lively representing all things to the eye at a distance, by the exact rules of art : as, landskips, towns, streets, palaces, churches, castles, fortifications, houses, gardens and walks, with their parts, as walls, doors, windows, stairs, chimneys, chambers, and shops, with their ornaments and furniture, as beds, tables, chests, cupboards, couches, chairs, stools, and other moveables, regular or irregular, in several postures : likewise rules for placing all sorts of figures, with their several postures, situation, and horizon; also, a treatise of shadows natural by the sun, torch, candle, and lamp : very useful and necessary for all painters, engravers, architects, embroiderers, carvers, goldsmiths, tapestry-workers, and all others that work by design / by a religious person of the Society of Jesus, a Parisian ; faithfully translated out of French, and illustrated with 150 copper cuts ; set forth in English by Robert Pricke for the lovers of art. ",
      copy_place_of_publication:        "England London.",
      copy_date_narrative:              "1698",
      evidence_location_in_book:        "Title Page",
      evidence_format:                  "Title Page (non-evidence)"
    }
  }

  let(:valid_context_image) {
    {
      column:                           "M",
      flickr_url:                       "BS_185_178207.jpg",
      url_to_catalog:                   "http://franklin.library.upenn.edu/record.html?id=FRANKLIN_5884548",
      copy_current_repository:          "Penn Libraries",
      copy_current_collection:          "Italian Culture Class Collection",
      copy_current_geographic_location: "Philadelphia",
      copy_call_number_shelf_mark:      "Folio IC55 B6388U 561s",
      copy_author:                      "Università di Bologna.",
      copy_title:                       "Statuta et priuilegia almae Vniuersitatis iuristarum Gymnasii Bononiensis.",
      copy_place_of_publication:        "Italy Bologna.",
      copy_date_narrative:              "1561",
      copy_printer_publisher_scribe:    "Benacci, Alessandro, 1528-1590?.",
      evidence_format:                  "Context Image (non-evidence)"
    }
  }

  let(:content_types_1) {
    {
      evidence_content_type: 'Amorial'
    }
  }

  let(:content_types_2) {
    {
      evidence_content_type: 'Signature | Price/Purchase Information'
    }
  }

  context 'factory' do
    it 'creates a RemediationAgent' do
      expect(create :remediation_agent).to be_a RemediationAgent
    end
  end

  context 'initialize' do
    it 'creates a RemediationAgent' do
      expect(RemediationAgent.create valid_attibutes).to be_a RemediationAgent
    end

    it 'builds a new RemediationAgent' do
      expect(RemediationAgent.new).to be_a RemediationAgent
    end
  end

  context 'validation' do
    it 'has an error on a blank remediation' do
      agent = RemediationAgent.new
      agent.valid?
      expect(agent.errors[:remediation]).to be_present
    end

    it 'does not have an error on a non-blank remediation' do
      agent = RemediationAgent.new remediation: build(:remediation)
      agent.valid?
      expect(agent.errors[:remediate]).to be_blank
    end
  end

  context '_handle_provenance' do
    it 'handles gender in provenance' do
      attrs = subject._handle_provenance bookplate_with_gender
      # binding.pry
      expect(attrs[:provenance_agents].first.name.gender).to eq 'other'
    end

    it "doesn't assign gender when two owners are present" do
      attrs = subject._handle_provenance bookplate_with_gender_two_owners
      expect(attrs[:provenance_agents].map { |a| a.name.gender }).to all be_nil
    end

    it "doesn't assign gender when two different agents are present" do
      attrs = subject._handle_provenance bookplate_with_gender_two_agents
      expect(attrs[:provenance_agents].map { |a| a.name.gender }).to all be_nil
    end
  end

  context '_create' do
    context '(non provenance)' do
      it 'returns nil when not_provenance is set' do
        expect(subject._create not_provenance_hash).to be_nil
      end

      it 'returns nil when format not present' do
        expect(subject._create no_format_hash).to be_nil
      end
    end # context (non provenance)

    context '(evidence)' do
      it 'creates evidence when format is Bookplate/Label' do
        expect(subject._create valid_bookplate).to be_an Evidence
      end
    end

    context '(title page)' do
      it 'creates title page when format matches Title Page' do
        expect(subject._create valid_title_page).to be_an TitlePage
      end
    end

    context '(context image)' do
      it 'creates context image when format matches Context Image' do
        expect(subject._create valid_context_image).to be_an ContextImage
      end
    end

  end # context _create

  context '_remap_attrs' do
    it 'remaps the attributes for a book' do
      remap = subject._remap_attrs Remediation::BOOK_ATTRIBUTES, valid_bookplate

      [:catalog_url,
       :repository,
       :collection,
       :geo_location,
       :call_number,
       :title,
       :creation_place,
       :creation_date].each do |obj_attr|
        expect(remap[obj_attr]).to be_present, "expected #{obj_attr.inspect} to be present in #{remap}"
      end # each
    end # it remaps
  end # context _remap_attrs

  context '_get_book' do
    it 'returns a book' do
      expect(subject._get_book valid_bookplate).to be_a Book
    end

    it 'creates a book' do
      expect { subject._get_book valid_bookplate }.to change { Book.count }.by 1
    end

    it 'finds a book' do
      create :book, repository: 'Penn Libraries', call_number: 'AC8 H3188 A825y'
      expect(subject._get_book(valid_bookplate).call_number).to eq 'AC8 H3188 A825y'
    end

    it 'does not create a book' do
      create :book, repository: 'Penn Libraries', call_number: 'AC8 H3188 A825y'
      expect { subject._get_book valid_bookplate }.not_to change { Book.count }
    end
  end

  context '_handle_content_types' do
    it 'creates an array of ConentTypes' do
      expect(subject._handle_content_types(content_types_1)[:content_types].first).to be_a ContentType
    end

    it 'returns two ContentTypes' do
      expect(subject._handle_content_types(content_types_2)[:content_types].size).to eq 2
    end

    it 'creates one ContentType' do
      expect { subject._handle_content_types(content_types_1) }.to change { ContentType.count }.by 1
    end

    it 'finds a ContentType' do
      # create the content type 'Armorial'
      subject._handle_content_types content_types_1
      # expect the method to find the content type the second time
      expect { subject._handle_content_types content_types_1 }.to change { ContentType.count }.by 0
    end
  end

  context '_create_evidence' do
    it 'creates an Evidence' do
      expect { subject._create_evidence valid_bookplate }.to change { Evidence.count }.by 1
    end
  end

  context '_create_context_image' do
    it 'creates an Evidence' do
      expect { subject._create_context_image valid_context_image }.to change { ContextImage.count }.by 1
    end
  end

  context '_create_title_page' do
    it 'creates an Evidence' do
      expect { subject._create_title_page valid_title_page }.to change { TitlePage.count }.by 1
    end
  end
end
