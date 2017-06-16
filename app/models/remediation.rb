class Remediation < ActiveRecord::Base
  include UserFields
  include SpreadsheetExtractor

  has_one :remediation_agent

  has_attached_file :spreadsheet
  validates_attachment_content_type :spreadsheet, content_type: ["application/vnd.ms-excel",
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"],
    message: "Only Excel files are allowed"

  validates :spreadsheet, presence: true

end
