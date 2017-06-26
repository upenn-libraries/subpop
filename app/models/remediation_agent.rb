class RemediationAgent < ActiveRecord::Base
  include SpreadsheetPhotoURL

  serialize :errors_log
  serialize :publications_log
  serialize :transformations_log

  belongs_to :remediation

  validates :remediation, presence: true

  STATUS_UNCHECKED            = 'unchecked'
  STATUS_CHECKING             = 'checking'
  STATUS_FAILED_CHECK         = 'failed-check'
  STATUS_PASSED_CHECK         = 'passed-checked'
  STATUS_PROCESSING           = 'processing'
  STATUS_COMPLETE             = 'complete'
  STATUS_COMPLETE_WITH_ERRORS = 'complete-with-errors'


  def not_provenance? col_hash
    col_hash[:evidence_format].blank?
  end

  def remediate
    set_total
    _check_spreadsheet
    return unless passed_check?
    _do_remediation
  end

  def set_status status
    self.update_attribute :status, status
  end

  def log_publication col_hash, publishable
    deets = { class_name: publishable.class.name, id: publishable.id }
    self.publications_log ||= []
    self.publications_log << { col_hash[:column].to_sym => deets }
  end

  def log_error col_hash, publishable, message
    deets = {}
    if publishable.present?
      deets.update(publishable: { type: publishable.class.name, id: publishable.id })
    end
    deets.update(message: message.to_s)
    (self.errors_log ||= []) << { col_hash[:column].to_sym => deets }
  end

  def create_and_publish col_hash
    publishable = _create col_hash
  end

  def _check_spreadsheet
    logger.info { "Pre-checking remediation: #{remediation.inspect}" }
    set_status STATUS_CHECKING
    begin
      remediation.check

      if remediation.problem_free?
        set_status STATUS_PASSED_CHECK
      else
        set_status STATUS_FAILED_CHECK
      end
    rescue Exception => e
      col_hash = { column: :spreadsheet }
      log_error col_hash, nil, "Error processing spreadsheet: #{e}"
      logger.error e.message
      logger.error e.backtrace.join("\n")
      set_status STATUS_FAILED_CHECK
    end
  end

  def _do_remediation
    logger.info { "Remediation remediation is problem free; processing #{remediation.inspect}" }
    set_status STATUS_PROCESSING

    remediation.spreadsheet_data.each do |col_hash|
      begin
        publishable = _create col_hash
        publishable.publish remediation.created_by_id, force: true
        log_publication col_hash, publishable
      rescue Exception => e
        log_error col_hash, publishable, e.to_s
      end
    end

    if self.errors_log.present?
      set_status STATUS_COMPLETE_WITH_ERRORS
    else
      set_status STATUS_COMPLETE
    end
  end

  def passed_check?
    ![STATUS_UNCHECKED, STATUS_CHECKING, STATUS_FAILED_CHECK].include? self.status
  end

  def _create col_hash
    return if not_provenance? col_hash
    case col_hash[:evidence_format]
    when /Context\s+Image/i
      _create_context_image col_hash
    when /Title\s+Page/i
      _create_title_page col_hash
    else
      _create_evidence col_hash
    end
  end

  def _create_context_image col_hash
    (context_attrs ||= {}).update book: _get_book(col_hash)
    context_attrs.update _handle_photo col_hash

    ContextImage.create! context_attrs
  end

  def _create_title_page col_hash
    (title_attrs ||= {}).update book: _get_book(col_hash)
    title_attrs.update _handle_photo col_hash

    TitlePage.create! title_attrs
  end

  def _create_evidence col_hash
    (evidence_attrs ||= {}).update book: _get_book(col_hash)
    evidence_attrs.update _handle_format col_hash
    evidence_attrs.update _handle_location col_hash
    evidence_attrs.update _handle_content_types col_hash
    evidence_attrs.update _handle_provenance(col_hash)
    evidence_attrs.update _remap_attrs(Remediation::EVIDENCE_ATTRIBUTES, col_hash)
    evidence_attrs.update _handle_photo col_hash

    Evidence.create! evidence_attrs
  end

  ##
  # Extract and delete format keys from column hash, returning a hash with
  # Evidence attribute keys with format names converted to code values. For
  # example:
  #
  #       {
  #          ...
  #          evidence_format:         "Bookplate/Label",
  #          ...
  #       }
  #
  # becomes:
  #
  #       {
  #          ...
  #          format:                  "bookplate_label",
  #          ...
  #       }
  #
  #
  # If `:evidence_other_format` is provided it is set as `:format_other`
  # regardless of the value of `:evidence_format`.
  def _handle_format col_hash
    format_attrs = {}

    code = Evidence::FORMATS_BY_NAME[col_hash.delete :evidence_format]
    format_attrs[:format] = code

    if col_hash[:evidence_other_format]
      format_attrs[:format_other] = col_hash.delete :evidence_other_format
    end

    format_attrs
  end

  ##
  # Extract and delete location key from column hash, returning a hash with
  # Evidence attribute keys with location names converted to code values. For
  # example:
  #
  #       {
  #          ...
  #          evidence_location_in_book:  "Inside Front Cover",
  #          ...
  #       }
  #
  # becomes:
  #
  #       {
  #          location_in_book:           "inside_front_cover",
  #       }
  #
  # If `:evidence_location_in_book` is not foound in
  # Evidence::LOCATIONS_BY_NAME, `:location_in_book` is set to `page_number`
  # and the `:page_number` attribute is set to the `col_hash` value of
  # `:evidence_location_in_book`.
  #
  def _handle_location col_hash
    loc_attrs = {}

    value = col_hash.delete :evidence_location_in_book
    return loc_attrs if value.blank?

    code  = Evidence::LOCATIONS_BY_NAME[value]

    if code.present?
      loc_attrs[:location_in_book]      = code
    else
      loc_attrs[:location_in_book]      = 'page_number'
      loc_attrs[:location_in_book_page] = value
    end

    loc_attrs
  end

  ##
  # Extract and delete content type key from column hash, returning a hash
  # with Evidence `:content_types` key and all content types pulled form the
  # database
  #
  #       {
  #          ...
  #          evidence_content_type:                  "Signature | Armorial",
  #          ...
  #       }
  #
  # becomes:
  #
  #       {
  #          content_types: [
  #               #<ContentType:0x007faeccc20c18 id: 4, name: "Signature"...>,
  #               #<ContentType:0x007faed02ede58 id: 1, name: "Armorial",...>
  #               ]
  #       }
  #
  def _handle_content_types col_hash
    type_attrs = {}

    values = col_hash.delete :evidence_content_type

    values.present? and values.split(/\|/).each do |val|
      ctype = ContentType.find_or_create_by name: val.strip
      (type_attrs[:content_types] ||= []) << ctype
    end

    type_attrs
  end

  ##
  # Extract and delete id keys from column hash, returning a hash with
  # Evidence `:provenance_agents` key and all provenance agents in the
  # col_hash.
  #
  #    {
  #       ...
  #       id_owner:     "Wilson, Carroll A., 1886-1947 | Barber, Joseph",
  #       id_librarian: "Chark, William",
  #       ...
  #    }
  # becomes:
  #
  #       {
  #          provenance_agents: [
  #               #<ProvenanceAgent:0x007f807f2123a0, ..., role: "owner",..., name_id: 8,...>,
  #               #<ProvenanceAgent:0x007f807f119930, ..., role: "owner",..., name_id: 9,...>,
  #               #<ProvenanceAgent:0x007f807f1429e8, ..., role: "librarian",..., name_id: 10,...>]
  #       }
  #
  # Note that pipe-separated names are turned into mulitple provenance agents.
  def _handle_provenance col_hash
    agents = {}

    role_names = Remediation::PROVENANCE_AGENT_ATTRIBUTES.flat_map do |heading_key,role_hash|
      names = col_hash.delete heading_key
      next [] unless names.present?
      { role: role_hash[:role], names: names.split(/\|/) }
    end

    return agents if role_names.blank?

    name_count = role_names.sum { |h| h[:names].size }
    # We only assign gender if we have one name; otherwise, we don't know
    # which name the gender goes with.
    gender_code = Name::gender_code col_hash.delete(:id_gender)
    if gender_code && name_count > 1
      gender_code = nil
    end
    # Create a ProvenanceAgent for each name
    role_names.each do |h|
      h[:names].each do |name|
        # Note: Gender is set only for those names that are created
        name_obj = Name.find_or_create_by name: name do |obj|
          obj.gender = gender_code
        end
        (agents[:provenance_agents] ||= []) << ProvenanceAgent.new(name: name_obj, role: h[:role])
      end
    end

    agents
  end

  ##
  # Extract and delete book attrs from col_hash and find or create and return
  # the relevant book based on repository name and call number/shelfmark.
  #
  def _get_book col_hash
    attrs = _remap_attrs Remediation::BOOK_ATTRIBUTES, col_hash

    (find_attrs ||= {})[:repository]  = attrs.delete :repository
    find_attrs[:call_number]          = attrs.delete :call_number

    Book.find_or_create_by find_attrs do |book|
      book.assign_attributes attrs
    end
  end

  def _handle_photo col_hash
    attrs = {}

    url_data = image_url_data col_hash.delete :flickr_url
    if url_data.flickr?
      pub_data = PublicationData.new metadata: url_data.flickr_info.to_json, flickr_id: url_data.flickr_id
      attrs.update publication_data: pub_data
      attrs.update photo: Photo.create!(image: open(url_data.image_url))
    else
      attrs.update photo: Photo.create!(image: open(url_data.image_url))
    end

    attrs
  end

  def _remap_attrs attr_map, col_hash
    attr_map.keys.inject({}) do |attrs, heading_key|
      # binding.pry
      object_attr = attr_map[heading_key]
      attrs.update(object_attr => col_hash.delete(heading_key)) if col_hash[heading_key]
      attrs
    end
  end
end
