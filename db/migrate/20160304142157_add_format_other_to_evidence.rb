class AddFormatOtherToEvidence < ActiveRecord::Migration
  def change
    add_column :evidence, :format_other, :string
  end
end
