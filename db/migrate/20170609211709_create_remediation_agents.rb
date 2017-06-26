class CreateRemediationAgents < ActiveRecord::Migration
  def change
    create_table :remediation_agents do |t|
      t.references :remediation, index: true, foreign_key: true
      t.text :transformations_log
      t.text :publications_log

      t.timestamps null: false
    end
  end
end
