class AddAcqSourceToBooks < ActiveRecord::Migration
  def change
    add_column :books, :acq_source, :string
  end
end
