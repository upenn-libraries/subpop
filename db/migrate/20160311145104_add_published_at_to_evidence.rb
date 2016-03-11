class AddPublishedAtToEvidence < ActiveRecord::Migration
  def change
    add_column :evidence, :published_at, :datetime
  end
end
