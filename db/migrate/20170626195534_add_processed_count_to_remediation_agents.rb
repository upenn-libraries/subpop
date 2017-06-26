class AddProcessedCountToRemediationAgents < ActiveRecord::Migration
  def change
    add_column :remediation_agents, :processed_count, :integer, default: 0
  end
end
