class CreateProvenanceAgents < ActiveRecord::Migration
  def change
    create_table :provenance_agents do |t|
      t.string :role
      t.references :evidence, index: true, foreign_key: true, null: false
      t.references :name, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
