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

  COLUMNS = [
    "Image URL",
    "Flickr Title",
    "Not Provenance",
    "Url to Catalog",
    "copy: current repository",
    "copy: current collection",
    "copy: current owner",
    "copy: current geographic location",
    "copy: call number/shelf mark",
    "copy: volume number",
    "copy: other id",
    "copy: author",
    "copy: title",
    "copy: place of publication",
    "copy: date of publication",
    "copy: date narrative",
    "copy: printer/publisher/scribe",
    "evidence: location in book",
    "evidence: format",
    "evidence: other format",
    "evidence: content type",
    "evidence: transcription",
    "evidence: translation",
    "evidence: date start",
    "evidence: date end",
    "evidence: date narrative",
    "evidence: date",
    "evidence: place",
    "evidence: citation",
    "evidence: comments",
    "id: owner",
    "id: librarian",
    "id: bookseller/auction house",
    "id: binder",
    "id: annotator",
    "id: unknown role",
    "Problems"
  ]

  COLUMN_HASH = COLUMNS.inject({}) { |col_hash,col|
    normal = ClassMethods.normalized_heading(col)
    col_hash[normal] = col
    col_hash
  }

  COLUMN_LETTERS = (1..MAX_COLUMN).inject(['A']) { |ra, i| ra << ra.last.succ  }

  FLICKR_URL_ROW    = 0
  FLICKR_TITLE_ROW  = 1

  ##
  # Return an array of hashes, containing all data in sheet. Each hash as  a
  # normalized header value as its keys, and all non-blank cell values as its
  # values. E.g.,
  #
  #    [{:column=>"C",
  #      :flick_url=>"https://www.flickr.com/photos/58558794@N07/6106275763",
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
  #      :flick_url=>"https://www.flickr.com/photos/58558794@N07/6106051679",
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

  ##
  # Retun a RubyXML workbook object
  def workbook
    @workbook ||= RubyXL::Parser.parse open_spreadsheet
  end

  def worksheet
    workbook[0]
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
  # Return true if value is one of the known headers. If a value is a symbol,
  # see if it is in COLUMN_HASH; otherwise, convert value to normalized
  # heading and check.
  def known_header? value
    return COLUMN_HASH.include? value if value.is_a? Symbol

    COLUMN_HASH.include? ClassMethods.normalized_heading value
  end

  ##
  # Return index of the first column with a value that is a known header
  #
  def heading_column
    return @heading_column if @heading_column.present?
    worksheet.each do |row|
      row && row.cells.each do |cell|
        next unless cell
        next unless cell.value
        if known_header? cell.value
          @heading_column = cell.column
          break
        end
      end
    end
    @heading_column
  end

  ##
  # Return all strings normalized and their addresses from heading_column on
  # sheet. Returns a hash in which keys are normalized strings and values are
  # arrays in format `[ROW, COLUMN]`:
  #
  #     {:flick_url=>[0, 1],
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
  # Does not check heading names against canonical header list.
  #
  def extract_heading_addresses
    addresses = {}
    addresses[:flick_url] =  [FLICKR_URL_ROW, heading_column]

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