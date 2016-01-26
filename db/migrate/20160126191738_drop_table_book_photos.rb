class DropTableBookPhotos < ActiveRecord::Migration
  def up
    drop_table :book_photos
  end

  def down
    raise "Migration cannot be reversed"
  end
end
