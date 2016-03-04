class RemovePaperclipColumnsFromEvidence < ActiveRecord::Migration
  def change
    remove_column :evidence, :image_file_name, :string
    remove_column :evidence, :image_content_type, :string
    remove_column :evidence, :image_file_size, :integer
    remove_column :evidence, :image_updated_at, :datetime
  end
end
