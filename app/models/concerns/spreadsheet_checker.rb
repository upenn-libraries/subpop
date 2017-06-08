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
end