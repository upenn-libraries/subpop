class CreateEvidencePhotos < ActiveRecord::Migration
  def change
    create_table :evidence_photos do |t|
      t.references :evidence, index: true, foreign_key: true
      t.references :photo, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
