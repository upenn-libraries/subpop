class CreateContextImages < ActiveRecord::Migration
  def change
    create_table :context_images do |t|
      t.references :book, index: true, foreign_key: true
      t.references :photo, index: true, foreign_key: true
      t.boolean :publishing_to_flickr
      t.boolean :deleted
      t.integer :created_by_id
      t.integer :updated_by_id

      t.timestamps null: false
    end
  end
end
