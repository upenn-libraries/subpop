class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :repository
      t.string :owner
      t.string :collection
      t.string :geo_location
      t.string :call_number
      t.string :catalog_url
      t.string :vol_number
      t.string :author
      t.string :title
      t.string :creation_place
      t.integer :creation_date
      t.string :publisher

      t.timestamps null: false
    end
  end
end
