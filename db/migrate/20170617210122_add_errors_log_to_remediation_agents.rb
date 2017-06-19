class AddErrorsLogToRemediationAgents < ActiveRecord::Migration
  def change
    add_column :remediation_agents, :errors_log, :text
  end
end
