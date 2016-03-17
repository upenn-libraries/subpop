class AddPublishingToTitlePages < ActiveRecord::Migration
  def change
    add_column :title_pages, :publishing_to_flickr, :boolean
  end
end
