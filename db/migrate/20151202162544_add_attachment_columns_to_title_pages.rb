class AddAttachmentColumnsToTitlePages < ActiveRecord::Migration
  def change
    add_attachment :title_pages, :image
  end
end
