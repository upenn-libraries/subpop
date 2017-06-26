##
# This concern extracts the data from an attached spreadsheet. Assumes the
# spreadsheet is in a PaperClip attachement attribute called spreadsheet.
#
module SpreadsheetExtractor
  extend ActiveSupport::Concern

  module ClassMethods
    def self.normalized_heading value
      value && value.to_s.downcase.gsub(/[^[:alnum:]]+/, ' ').strip.gsub(/ /, '_').to_sym
    end
  end

  MAX_COLUMN = 10000

  HEADER_HASH = {
    image_url:                        "Image URL",
    file_name:                        "File name",
    flickr_url:                       "Flickr URL",
    flickr_title:                     "Flickr Title",
    not_provenance:                   "Not Provenance",
    url_to_catalog:                   "Url to Catalog",
    copy_current_repository:          "copy: current repository",
    copy_current_collection:          "copy: current collection",
    copy_current_owner:               "copy: current owner",
    copy_current_geographic_location: "copy: current geographic location",
    copy_call_number_shelf_mark:      "copy: call number/shelf mark",
    copy_volume_number:               "copy: volume number",
    copy_other_id:                    "copy: other id",
    copy_author:                      "copy: author",
    copy_title:                       "copy: title",
    copy_place_of_publication:        "copy: place of publication",
    copy_date_of_publication:         "copy: date of publication",
    copy_date_narrative:              "copy: date narrative",
    copy_printer_publisher_scribe:    "copy: printer/publisher/scribe",
    copy_acquisition_source:          "copy: acquisition source",
    copy_comments:                    "copy: comments",
    evidence_location_in_book:        "evidence: location in book",
    evidence_format:                  "evidence: format",
    evidence_other_format:            "evidence: other format",
    evidence_content_type:            "evidence: content type",
    evidence_transcription:           "evidence: transcription",
    evidence_translation:             "evidence: translation",
    evidence_date_start:              "evidence: date start",
    evidence_date_end:                "evidence: date end",
    evidence_date_narrative:          "evidence: date narrative",
    evidence_date:                    "evidence: date",
    evidence_place:                   "evidence: place",
    evidence_citation:                "evidence: citation",
    evidence_comments:                "evidence: comments",
    id_owner:                         "id: owner",
    id_librarian:                     "id: librarian",
    id_bookseller_auction_house:      "id: bookseller/auction house",
    id_binder:                        "id: binder",
    id_annotator:                     "id: annotator",
    id_unknown_role:                  "id: unknown role",
    id_gender:                        "id: gender",
    problems:                         "Problems"
  }

  BOOK_ATTRIBUTES = {
    url_to_catalog:                   :catalog_url,
    copy_current_repository:          :repository,
    copy_current_collection:          :collection,
    copy_current_owner:               :owner,
    copy_current_geographic_location: :geo_location,
    copy_call_number_shelf_mark:      :call_number,
    copy_volume_number:               :vol_number,
    copy_other_id:                    :other_id,
    copy_author:                      :author,
    copy_title:                       :title,
    copy_place_of_publication:        :creation_place,
    copy_date_of_publication:         :creation_date,
    copy_date_narrative:              :date_narrative,
    copy_printer_publisher_scribe:    :publisher,
    copy_acquisition_source:          :acq_source,
    copy_comments:                    :comment_book
  }

  EVIDENCE_ATTRIBUTES = {
    evidence_location_in_book:        :location_in_book,
    evidence_format:                  :format,
    evidence_other_format:            :format_other,
    evidence_content_type:            :content_types,
    evidence_transcription:           :transcription,
    evidence_translation:             :translation,
    evidence_date_start:              :year_start,
    evidence_date_end:                :year_end,
    evidence_date_narrative:          :date_narrative,
    evidence_date:                    :year_when,
    evidence_place:                   :where,
    evidence_citation:                :citations,
    evidence_comments:                :comments
  }

  PROVENANCE_AGENT_ATTRIBUTES = {
    id_owner:                         { role: 'owner' },
    id_librarian:                     { role: 'librarian' },
    id_bookseller_auction_house:      { role: 'bookseller' },
    id_binder:                        { role: 'binder' },
    id_annotator:                     { role: 'annotator' },
    id_unknown_role:                  { role: 'unknown' }
  }

  CONTEXT_IMAGE_ATTRIBUTES = { }

  TITLE_PAGE_ATTRIBUTES = { }

  HEADERS = HEADER_HASH.values

  COLUMN_LETTERS = (1..MAX_COLUMN).inject(['A']) { |ra, i| ra << ra.last.succ  }

  FLICKR_URL_ROW    = 0
  FLICKR_TITLE_ROW  = 1

  ##
  # Return an array of hashes, containing all data in sheet. Each hash as  a
  # normalized heading value as its keys, and all non-blank cell values as its
  # values. E.g.,
  #
  #    [{:column=>"C",
  #      :flickr_url=>"https://www.flickr.com/photos/58558794@N07/6106275763",
  #      :url_to_catalog=>
  #        "http://franklin.library.upenn.edu/record.html?id=FRANKLIN_5050597",
  #      :copy_current_repository=>"Penn Libraries",
  #      :copy_current_collection=>"American Culture Class Collection",
  #      :copy_current_geographic_location=>"Philadelphia",
  #      :copy_call_number_shelf_mark=>"AC8 H3188 A825y",
  #      :copy_title=>
  #        "Youth's keepsake : A Christmas and New Year's gift for young people.",
  #      :copy_place_of_publication=>"United States Massachusetts Boston.",
  #      :copy_date_of_publication=>"1835",
  #      :evidence_format=>"Bookplate/Label",
  #      :evidence_comments=>
  #        "Bookplate of Carroll Atwood Wilson (1886-1947), American lawyer \
  #         (he served as chief legal counsel to the Guggenheims) and book \
  #          collector.",
  #      :id_owner=>"Wilson, Carroll A. (Carroll Atwood), 1886-1947"},
  #     {:column=>"D",
  #      :flickr_url=>"https://www.flickr.com/photos/58558794@N07/6106051679",
  #      :url_to_catalog=>
  #       "http://franklin.library.upenn.edu/record.html?id=FRANKLIN_5057263",
  #      :copy_current_repository=>"Penn Libraries",
  #      :copy_current_collection=>"Latin Culture Class Collection",
  #      :copy_current_geographic_location=>"Philadelphia",
  #      :copy_call_number_shelf_mark=>"LatC Qu457.3 1692",
  #      :copy_title=>
  #        "M. Fab. Quintiliani Declamationum liber : cum eiusdem (ut nonnullis \
  #         visum) Dialogo de causis corruptae eloquentiae : quae omnia notis \
  #         illustrantur. ",
  #      :copy_place_of_publication=>"England Oxford.",
  #      :copy_date_of_publication=>"1692",
  #      :copy_printer_publisher_scribe=>"Sheldonian Theatre.",
  #      :evidence_format=>"Inscription",
  #      :evidence_transcription=>
  #         "...autres que le s[.]avant Mr. Gravius m'a assure, ...",
  #      :evidence_translation=>
  #        "...others that the scholar Monsieur Gravius has assured...",
  #      :evidence_comments=>
  #        "Late 17th-century (ca. 1692-1696) inscription ...""},
  #      #... ]
  #
  def spreadsheet_data
    return @spreadsheet_data if @spreadsheet_data.present?

    @spreadsheet_data = []
    addresses         = extract_heading_addresses

    offset            = heading_column + 1
    (offset..MAX_COLUMN).each do |col_index|
      # we stop when we run out of URLs
      break unless worksheet[FLICKR_URL_ROW] && worksheet[FLICKR_URL_ROW][col_index]
      (col_data ||= {})[:column] = COLUMN_LETTERS[col_index]
      addresses.each  do |head, addr|
        row_index = addr.first
        cell = worksheet[row_index] && worksheet[row_index][col_index]
        col_data[head] = cell.value unless cell_empty? cell
      end
      @spreadsheet_data << col_data
    end
    @spreadsheet_data
  end

  def entry_count
    spreadsheet_data.size
  end

  ##
  # Retun a RubyXML workbook object
  def workbook
    @workbook ||= RubyXL::Parser.parse open_spreadsheet
  end

  def worksheet
    workbook[0]
  end

  def field_name col_sym
    HEADER_HASH.fetch col_sym
  end

  ##
  # Return the spreasheet as a File object
  def open_spreadsheet
    return open self.spreadsheet.path if self.persisted?

    # yuckeroo; RubyXL has to have a path or file object. It won't work with
    # a string, which is what's returned by read. So here we force grab the
    # tempfile from the queued spreadsheet
    orig = self.spreadsheet.queued_for_write[:original]
    orig.instance_eval '@tempfile'
  end

  ##
  # Return true if value is one of the known headings. If a value is a symbol,
  # see if it is in HEADER_HASH; otherwise, convert value to normalized
  # heading and check.
  def known_heading? value
    return known_headings.include? value if value.is_a? Symbol

    known_headings.include? ClassMethods.normalized_heading value
  end

  ##
  # Return index of the first column with a value that is a known heading
  def heading_column
    return @heading_column if @heading_column.present?
    worksheet.each do |row|
      row && row.cells.each do |cell|
        next unless cell
        next unless cell.value
        if known_heading? cell.value
          @heading_column = cell.column
          break
        end
      end
    end
    @heading_column
  end

  def headings
    @headings ||= extract_heading_addresses
  end

  def known_headings
    HEADER_HASH.keys + %i{ file_name flickr_url }
  end

  ##
  # Return all strings normalized and their addresses from heading_column on
  # sheet. Returns a hash in which keys are normalized strings and values are
  # arrays in format `[ROW, COLUMN]`:
  #
  #     {:flickr_url=>[0, 1],
  #      :file_name=>[1, 1],
  #      :not_provenance=>[3, 1],
  #      :url_to_catalog=>[4, 1],
  #      :copy_current_repository=>[5, 1],
  #      :copy_current_collection=>[6, 1],
  #      :copy_current_owner=>[7, 1],
  #      :copy_current_geographic_location=>[8, 1],
  #      :copy_call_number_shelf_mark=>[9, 1],
  #      :copy_volume_number=>[10, 1],
  #      :copy_other_id=>[11, 1],
  #      # ... etc.
  #      :presentation=>[38, 1]}
  #
  # Does not check heading names against canonical heading list.
  #
  def extract_heading_addresses
    addresses = {}
    addresses[:flickr_url] =  [FLICKR_URL_ROW, heading_column]

    (0..200).each do |i|
      row = worksheet[i]
      val = row && row[heading_column] && row[heading_column].value
      key = ClassMethods.normalized_heading val if val
      addresses[key] ||= [i, heading_column] if key
    end
    addresses
  end

  def cell_empty? cell
    cell.blank? || cell.value.blank?
  end
end