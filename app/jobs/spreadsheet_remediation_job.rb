class SpreadsheetRemediationJob < ActiveJob::Base
  queue_as :default

  def perform remediation_agent
    binding.pry
    remediation_agent.remediate
    remediation_agent.save!
    binding.pry
  end
end