class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :flickr_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
