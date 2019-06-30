class CreateRemediations < ActiveRecord::Migration
  def change
    create_table :remediations do |t|
      t.text :problems
      t.integer :created_by_id
      t.integer :updated_by_id

      t.timestamps null: false
    end
  end
end
