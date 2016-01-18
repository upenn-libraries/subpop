class CreateEvidence < ActiveRecord::Migration
  def change
    create_table :evidence do |t|
      t.references :book, index: true, foreign_key: true
      t.string :format
      t.string :content_type
      t.string :location_in_book
      t.string :location_in_book_page
      t.text :transcription
      t.integer :year_when
      t.integer :year_start
      t.integer :year_end
      t.string :date_narrative
      t.string :where
      t.text :comments

      t.timestamps null: false
    end
  end
end
