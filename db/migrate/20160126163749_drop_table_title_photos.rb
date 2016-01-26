class DropTableTitlePhotos < ActiveRecord::Migration
  def up
    drop_table :title_page_photos
  end

  def down
    raise "Migration cannot be reversed"
  end
end
