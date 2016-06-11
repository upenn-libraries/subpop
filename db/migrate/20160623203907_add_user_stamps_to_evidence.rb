class AddUserStampsToEvidence < ActiveRecord::Migration
  def change
    add_column :evidence, :created_by_id, :integer
    add_column :evidence, :updated_by_id, :integer

    Evidence.update_all created_by_id: User.first.id, updated_by_id: User.first.id
  end
end
