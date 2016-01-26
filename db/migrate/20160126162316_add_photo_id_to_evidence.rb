class AddPhotoIdToEvidence < ActiveRecord::Migration
  def change
    add_reference :evidence, :photo, index: true, foreign_key: true
    add_column :evidence, :flickr_id, :string
    add_column :evidence, :flickr_info, :text

    add_index :evidence, :flickr_id
  end
end
