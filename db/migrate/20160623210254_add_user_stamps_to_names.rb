class AddUserStampsToNames < ActiveRecord::Migration
  def change
    add_column :names, :created_by_id, :integer
    add_column :names, :updated_by_id, :integer

    Name.update_all created_by_id: User.first.id, updated_by_id: User.first.id
  end
end
