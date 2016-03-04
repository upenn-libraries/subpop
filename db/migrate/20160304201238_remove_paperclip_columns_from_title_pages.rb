class RemovePaperclipColumnsFromTitlePages < ActiveRecord::Migration
  def change
    remove_column :title_pages, :image_file_name, :string
    remove_column :title_pages, :image_content_type, :string
    remove_column :title_pages, :image_file_size, :integer
    remove_column :title_pages, :image_updated_at, :datetime
  end
end
