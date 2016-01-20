class CreateTitlePagePhotos < ActiveRecord::Migration
  def change
    create_table :title_page_photos do |t|
      t.references :title_page, index: true, foreign_key: true
      t.references :photo, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
