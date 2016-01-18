class AddSammelbandToBooks < ActiveRecord::Migration
  def change
    add_column :books, :sammelband, :boolean
  end
end
