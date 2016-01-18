class AddAttachmentColumnsToPhotos < ActiveRecord::Migration
  def up
    add_attachment :photos, :image
  end

  def remove
    remove_attachment :photos, :image
  end
end
