class AddCitationsToEvidence < ActiveRecord::Migration
  def change
    add_column :evidence, :citations, :text
  end
end
