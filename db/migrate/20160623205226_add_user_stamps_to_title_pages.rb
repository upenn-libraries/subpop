class AddUserStampsToTitlePages < ActiveRecord::Migration
  def change
    add_column :title_pages, :created_by_id, :integer
    add_column :title_pages, :updated_by_id, :integer

    TitlePage.update_all created_by_id: User.first.id, updated_by_id: User.first.id
  end
end
