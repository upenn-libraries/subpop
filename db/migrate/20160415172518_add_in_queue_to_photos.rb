class AddInQueueToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :in_queue, :boolean, default: true
    Photo.update_all in_queue: true
  end
end
