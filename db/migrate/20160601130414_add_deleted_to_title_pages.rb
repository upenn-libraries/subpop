class AddDeletedToTitlePages < ActiveRecord::Migration
  def up
    add_column :title_pages, :deleted, :boolean, default: false
    TitlePage.update_all deleted: false
  end

  def down
    remove_column :title_pages, :deleted
  end
end
