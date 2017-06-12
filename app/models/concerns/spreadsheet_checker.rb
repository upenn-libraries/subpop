##
# This concern is used to validate spreadsheet content.
#
module SpreadsheetChecker
  extend ActiveSupport::Concern

  def check
    self.problems = []
    sheet = Roo::Excelx.new(spreadsheet.path)
  end

  def problem_free?
    check
    self.problems.blank?
  end

  # methods to be defined in body of SpreadSheetColumn class
  # -------------------------------------------------------------------
  def check_year field_name, value, required=false
    return [] if required == false && value.blank?
    return [field_name, "is required"] if value.blank?
    return [field_name, "is not a valid year"] unless valid_year? value
    [] 
  end

  def valid_year? value
    return false unless value.to_s.strip.to_i.to_s == value.to_s.strip
    (-5000..3000).include? value.to_i
  end
  # ------------------------------------------------------------------

end


# class SpreadSheetColumn (seperate file in concerns folder)
# @column_number
# initialize column objects in batches of ~30 ?