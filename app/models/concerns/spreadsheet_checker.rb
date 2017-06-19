##
# This concern is used to validate spreadsheet content.
#

module SpreadsheetChecker
  extend ActiveSupport::Concern

 def problem_free?
   check
   self.problems.blank?
 end 

 def check
   self.problems = []
   sheet = Roo::Excelx.new(spreadsheet.path)
   return self.problems = ['bad spreadsheet'] unless verify_headings(sheet) 
   spreadsheet_data.each do |entry| # how to invoke?
     heading = entry[:column]
     entry_problems = check_entry(entry)
     self.problems << [heading, entry_problems] unless entry_problems.blank?
   end
 end


  def verify_headings sheet

  end

  # def normalize_heading heading
  #   heading.strip.gsub(/[^[:alnum:]_]+/, '')
  # end

  def check_entry entry_hash
    return ['no photo'] unless check_for_photo(entry_hash) 
    return check_non_provenance(entry_hash) if entry_hash[:evidence_format].blank?

    problems = entry_hash.keys.inject([]) do |list, field|
      field_problems = check_field(field entry[field) 
      list << field_problems unless field_problems.blank?
    end
    @other_format_flag = false
    problems
  end

  def check_photo entry
    path_prescence = %i(flickr_url file_name).map{ |f| entry[f].blank? }
    return false unless path_prescence.compact = [true]
    path_location = path_prescence[0] ? 0 : 1 
    path = %i(flickr_url file_name).map{ entry[f] }[path_location]
    path_location == 0 ? check_flickr_photo(path) : check_other_photo(path)
  end

  def check_flickr_photo path
  end

  def check_other_photo path
  end

  def check_non_provenance entry
  end

  def check_field(field_name, value)
    required_field = REQUIRED_FIELDS.include?(field_name)
    required_field = true if field_name == other_format && @other_format_flag
    @other_format_flag = true if field_name == :evidence_other_format

    return [field_name, 'is required'] if value.blank? && required_field
    return [] if value.blank? 
    # if not blank
    return check_list_field(field_name, value) if LIST_FIELDS.include?(field_name)
    return check_year_field(field_name, value) if YEAR_FIELDS.include?(field_name)
    []
  end

  def check_list_field field_name, value
    return check_piped_content_type(value) if field_name == :evidence_content_type && value.include?('|')
    return [] if VALID_LIST_VALUES[field_name].include? value
    [field_name, 'has invalid data entered']
  end

  def check_piped_content_type value
    types = value.split '|'
    no_problems = types.all? do |t| 
      VALID_LIST_VALUES[:evidence_content_type].include? t.strip 
    end
    return [] if no_problems
    [:evidence_content_type, 'has invalid data entered']
  end

  def check_year_field field_name, value
    return [] if valid_year?(value)
    [field_name, 'is not a valid year']
  end

  def valid_year? value
    return false unless value.to_s.strip.to_i.to_s == value.to_s.strip
    (-5000..3000).include? value.to_i
  end


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


