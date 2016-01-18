class CreateNames < ActiveRecord::Migration
  def change
    create_table :names do |t|
      t.string :name, null: false
      t.integer :year_start
      t.integer :year_end
      t.string :viaf_id
      t.string :comment

      t.timestamps null: false
    end

    add_index :names, :name, unique: true
  end
end
