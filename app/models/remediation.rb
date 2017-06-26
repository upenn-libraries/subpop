class Remediation < ActiveRecord::Base
  include UserFields
  include SpreadsheetExtractor
  include SpreadsheetChecker

  serialize :problems

  has_one :remediation_agent, dependent: :destroy

  has_attached_file :spreadsheet
  validates_attachment_content_type :spreadsheet, content_type: ["application/vnd.ms-excel",
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"],
    message: "Only Excel files are allowed"

  validates :spreadsheet, presence: true

  delegate :publications_log, to: :remediation_agent, prefix: false, allow_nil: true
  delegate :status, to: :remediation_agent, prefix: true, allow_nil: true

end
