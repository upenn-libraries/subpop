class AddPublishingToEvidence < ActiveRecord::Migration
  def change
    add_column :evidence, :publishing_to_flickr, :boolean
  end
end
