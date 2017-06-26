class AddTotalCountToRemediationAgents < ActiveRecord::Migration
  def change
    add_column :remediation_agents, :total_count, :integer
  end
end
