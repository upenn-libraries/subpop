class AddUserStampsToBooks < ActiveRecord::Migration
  def change
    add_column :books, :created_by_id, :integer
    add_column :books, :updated_by_id, :integer

    Book.update_all created_by_id: User.first.id, updated_by_id: User.first.id
  end
end
