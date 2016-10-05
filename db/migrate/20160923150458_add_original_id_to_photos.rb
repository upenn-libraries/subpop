class AddOriginalIdToPhotos < ActiveRecord::Migration
  def change
    change_table :photos do |t|
      t.references :original, index: true
    end
  end
end
