class DropTableEvidencePhotos < ActiveRecord::Migration
  def up
    drop_table :evidence_photos
  end

  def down
    raise "Migration cannot be reversed"
  end
end
