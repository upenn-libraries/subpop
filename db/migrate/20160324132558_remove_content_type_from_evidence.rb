class RemoveContentTypeFromEvidence < ActiveRecord::Migration
  def change
    remove_column :evidence, :content_type, :string
  end
end
