class SpreadsheetRemediationJob < ActiveJob::Base
  queue_as :default

  def perform remediation_agent
    remediation_agent.remediate
    remediation_agent.save!
  end
end