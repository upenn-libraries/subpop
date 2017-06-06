class AddSpreadsheetToRemediations < ActiveRecord::Migration
  def up
    add_attachment :remediations, :spreadsheet
  end

  def down
    remove_attachment :remediations, :spreadsheet
  end
end
