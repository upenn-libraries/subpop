class AddPhotoIdToTitlePages < ActiveRecord::Migration
  def change
    add_reference :title_pages, :photo, index: true, foreign_key: true
    add_column :title_pages, :flickr_id, :string
    add_column :title_pages, :flickr_info, :text

    add_index :title_pages, :flickr_id
  end
end
