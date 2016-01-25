class AddFlickrInfoToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :flickr_info, :text
  end
end
