class AddTranslationToEvidence < ActiveRecord::Migration
  def change
    add_column :evidence, :translation, :text
  end
end
