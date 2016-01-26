class RemoveColumnsFlickrIdFlickrInfoFromPhotos < ActiveRecord::Migration
  def change
    remove_column :photos, :flickr_id, :string
    remove_column :photos, :flickr_info, :text
  end
end
