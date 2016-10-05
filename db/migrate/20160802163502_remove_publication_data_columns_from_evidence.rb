class RemovePublicationDataColumnsFromEvidence < ActiveRecord::Migration
  def restore_publication_data pub
    return if pub.publication_data.blank?
    pub_data = pub.publication_data
    pub.update_columns(
      flickr_id:    pub_data.flickr_id,
      flickr_info:  pub_data.metadata,
      published_at: pub_data.updated_at)
  end

  def up
    remove_column :evidence, :flickr_id, :string
    remove_column :evidence, :flickr_info, :text
    remove_column :evidence, :published_at, :datetime
  end

  def down
    add_column :evidence, :flickr_id, :string
    add_column :evidence, :flickr_info, :text
    add_column :evidence, :published_at, :datetime

    Evidence.find_each { |pub| restore_publication_data pub }
  end
end
