class AddBookIdToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :book_id, :integer
  end
end
