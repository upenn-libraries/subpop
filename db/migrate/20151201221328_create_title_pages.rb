class CreateTitlePages < ActiveRecord::Migration
  def change
    create_table :title_pages do |t|
      t.references :book, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
