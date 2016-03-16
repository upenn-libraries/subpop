class AddPublishedAtToTitlePages < ActiveRecord::Migration
  def change
    add_column :title_pages, :published_at, :datetime
  end
end
