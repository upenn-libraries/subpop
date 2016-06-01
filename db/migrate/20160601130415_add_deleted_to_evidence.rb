class AddDeletedToEvidence < ActiveRecord::Migration
  def up
    add_column :evidence, :deleted, :boolean, default: false
    Evidence.update_all deleted: false
  end

  def down
    remove_column :evidence, :deleted
  end
end
