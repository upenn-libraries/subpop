class AddStatusToRemediationAgents < ActiveRecord::Migration
  def change
    add_column :remediation_agents, :status, :string, default: 'unchecked'
  end
end
