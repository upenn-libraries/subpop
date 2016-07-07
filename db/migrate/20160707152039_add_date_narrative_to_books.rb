class AddDateNarrativeToBooks < ActiveRecord::Migration
  def change
    add_column :books, :date_narrative, :string
  end
end
