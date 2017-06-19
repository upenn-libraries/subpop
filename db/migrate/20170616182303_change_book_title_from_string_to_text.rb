class ChangeBookTitleFromStringToText < ActiveRecord::Migration
  def up
    change_column :books, :title, :text
  end

  def down
    change_column :books, :title, :string
  end
end
