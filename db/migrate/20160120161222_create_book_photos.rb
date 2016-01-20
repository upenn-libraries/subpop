class CreateBookPhotos < ActiveRecord::Migration
  def change
    create_table :book_photos do |t|
      t.references :book, index: true, foreign_key: true
      t.references :photo, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
