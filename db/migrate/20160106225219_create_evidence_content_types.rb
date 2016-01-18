class CreateEvidenceContentTypes < ActiveRecord::Migration
  def change
    create_table :evidence_content_types do |t|
      t.references :evidence, index: true, foreign_key: true
      t.references :content_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
