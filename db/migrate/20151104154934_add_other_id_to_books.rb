class AddOtherIdToBooks < ActiveRecord::Migration
  def change
    add_column :books, :other_id, :string
    add_column :books, :other_id_type, :string
  end
end
