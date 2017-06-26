##
# This concern is used to validate spreadsheet content.
#

module SpreadsheetChecker
  extend ActiveSupport::Concern

  include SpreadsheetPhotoURL

  def check
    verify_headings
    self.save
    return if self.problems.present?
    spreadsheet_data.each{ |entry| check_entry(entry) }
    self.save
    true
  end

  def problem_free?
    self.problems.blank?
  end

  def fetch_problem col_sym
    self.problems ||= {}
    self.problems[col_sym] || []
  end

  def verify_headings
    headings.keys.each do |heading_key|
      add_problem(heading_key, "invalid heading: #{heading_key}", :headings) unless known_heading?(heading_key)
    end

    REQUIRED_FIELDS.each do |field|
      add_problem(field, "missing required field: '#{field_name field}'", :headings) unless headings[field]
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
    data.live? or add_problem(:flickr_url, "doesn't point to a live file #{(data.image_url)}")
  end

  def check_field(heading, value)
    required_field     = true if REQUIRED_FIELDS.include?(heading)
    required_field     = true if (heading == :evidence_other_format && @other_format_flag)
    @other_format_flag = (heading == :evidence_format && value == 'Other Format')

    return add_problem(heading, 'is required') if required_field && value.blank?
    return                                     if value.blank?
    return check_format value                  if heading == :evidence_format
    return check_piped_content_type value      if heading == :evidence_content_type
    return check_year_field(heading, value)    if YEAR_FIELDS.include?(heading)
    nil
  end

  def check_format value
    # format is required, but that's checked elsewhere
    return if value.blank?
    return if VALID_LIST_VALUES[:evidence_format].include? value.to_s.strip
    add_problem :evidence_format, "'#{value}' is not a valid value"
  end

  def check_piped_content_type values
    values.to_s.strip.split('|').each do |value|
      next if valid_content_type? value
      add_problem :evidence_content_type, "#{value} is not a valid value"
    end
  end

  def valid_content_type? value
    # blank is valid
    return true if value.blank?

    # THIS IS IMPORTANT!!!! --- ContentTypes are configurable. We cache
    # values from the database for the scope of a single spreadsheet check.
    # Setting valid content_types in a constant could (would definitely?)
    # prevent updating of the information for subsequent checks.
    @valid_content_types ||= ContentType.select(:name).map &:name

    return true if @valid_content_types.include? value.to_s.strip
  end

  def check_year_field heading, value
    return if valid_year?(value)
    add_problem(heading, 'is not a valid year')
  end

  def valid_year? value
    return false unless value.to_s.strip.to_i.to_s == value.to_s.strip
    (-5000..3000).include? value.to_i
  end

  def add_problem heading, message, problem_type = nil
    key = problem_type || @col_sym
    self.problems ||= {}
    s = format_message(heading, message)
    (self.problems[key] ||= []) << s
  end

  def format_message heading, message
    "ERROR--[#{heading}]: #{message}"
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

  YEAR_FIELDS = %i(
    copy_date_of_publication
    evidence_date
    evidence_date_start
    evidence_date_end
  )

  VALID_LIST_VALUES = {
    evidence_format: Evidence::FORMAT_NAMES + [
      "Title Page (non-evidence)",
      "Context Image (non-evidence"]
  }
end


