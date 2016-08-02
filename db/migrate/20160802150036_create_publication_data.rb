class CreatePublicationData < ActiveRecord::Migration
  def migrate_data pub
    return unless pub.on_flickr?
    data = PublicationData.create!(
      flickr_id:            pub.flickr_id,
      metadata:             pub.flickr_info,
      publishable:          pub)
    data.update_columns created_at: pub.published_at, updated_at: pub.published_at
  end

  def up
    create_table :publication_data do |t|
      t.string :flickr_id
      t.text :metadata
      t.integer :publishable_id
      t.string :publishable_type

      t.timestamps null: false
    end

    Evidence.find_each { |e| migrate_data e }
    TitlePage.find_each { |t| migrate_data t }
  end

  def down
    drop_table :publication_data
  end
end
