class AddAttachmentColumnsToEvidence < ActiveRecord::Migration
  def change
    add_attachment :evidence, :image
  end
end
