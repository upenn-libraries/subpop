##
# This concern is used to validate spreadsheet content.
#

module SpreadsheetChecker
  extend ActiveSupport::Concern

  def problem_free?
   self.problems.blank?
  end

  def fetch_problem col_sym
    self.problems ||= {}
    self.problems[col_sym] || []
  end

  def check
   verify_headings
   return if self.problems.present?
   spreadsheet_data.each{ |entry| check_entry(entry) }
   true
  end

  def verify_headings
    headings.keys.each do |heading_key|
      add_problem(nil, "ERROR--invalid heading [#{heading_key}]", :headings) unless known_heading?(heading_key)
    end
    REQUIRED_FIELDS.each do |field|
      add_problem(nil, "ERROR--missing required field [#{field}]", :headings) unless headings[field]
    end
  end

  def check_entry entry_hash
    return unless entry_hash[:evidence_format]
    @col_sym = entry_hash[:column].to_sym
    check_photo(entry_hash[:flickr_url])
    FIELDS_TO_CHECK.each{ |f| check_field(f, entry_hash[f]) }
    @other_format_flag = false
    @col_sym = nil
  end

  def check_photo url_or_filename
    return add_problem(:flickr_url, 'is required') if url_or_filename.blank?
    data = image_url_data(url_or_filename)
    data.live? or add_problem(:flickr_url, "doesn't point to a live file #{(date.image_url)}")
  end

  def check_field(field_name, value)
    required_field = REQUIRED_FIELDS.include?(field_name)
    required_field = true if field_name == :evidence_other_format && @other_format_flag
    @other_format_flag = true if field_name == :evidence_format && (value == 'Other Format')

    return add_problem(field_name, 'is required') if value.blank? && required_field
    return if value.blank?
    return check_list_field(field_name, value) if LIST_FIELDS.include?(field_name)
    return check_year_field(field_name, value) if YEAR_FIELDS.include?(field_name)
    nil
  end

  def check_list_field field_name, value
    return check_piped_content_type(value) if field_name == :evidence_content_type && value.include?('|')
    return if VALID_LIST_VALUES[field_name].include? value
    add_problem(field_name, 'has invalid data entered')
  end

  def check_piped_content_type value
    types = value.split '|'
    no_problems = types.all? do |t|
      VALID_LIST_VALUES[:evidence_content_type].include? t.strip
    end
    return if no_problems
    add_problem(:evidence_content_type, 'has invalid data entered ("#{value}")')
  end

  def check_year_field field_name, value
    return if valid_year?(value)
    add_problem(field_name, 'is not a valid year')
  end

  def valid_year? value
    return false unless value.to_s.strip.to_i.to_s == value.to_s.strip
    (-5000..3000).include? value.to_i
  end

  def add_problem field_name, message, problem_type = nil
    key = @col_sym unless problem_type
    self.problems ||= {}
    s = format_message(field_name, message)
    (self.problems[key] ||= []) << s
  end

  def format_message field_name, message
    "ERROR--[#{field_name}]: #{message}"
  end

  def assemble_message
    message = ''
    self.problems.keys.sort.each{ |k| message << "#{k} problems[k] \n\n" }
    message
  end



  FIELDS_TO_CHECK = %i(
    copy_current_repository
    copy_title
    copy_call_number_shelf_mark
    copy_date_of_publication
    evidence_format
    evidence_other_format
    evidence_content_type
    evidence_date
    evidence_date_start
    evidence_date_end
  )

  REQUIRED_FIELDS = %i(
    copy_current_repository
    copy_title
    copy_call_number_shelf_mark
    evidence_format
    )

  LIST_FIELDS = %i(
    evidence_format
    evidence_content_type
    )

  YEAR_FIELDS = %i(
    copy_date_of_publication
    evidence_date
    evidence_date_start
    evidence_date_end
  )

  VALID_LIST_VALUES = {

    evidence_format: [
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
    ],

    evidence_content_type: [
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
  }
end


