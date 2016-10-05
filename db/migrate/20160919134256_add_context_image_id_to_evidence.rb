class AddContextImageIdToEvidence < ActiveRecord::Migration
  def change
    add_reference :evidence, :context_image, index: true, foreign_key: true
  end
end
