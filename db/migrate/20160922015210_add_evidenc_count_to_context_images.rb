class AddEvidencCountToContextImages < ActiveRecord::Migration
  def up
    add_column :context_images, :evidence_count, :integer
    ContextImage.reset_column_information
    ContextImage.all.each do |ci|
      ci.update_column :evidence_count, ci.evidence.length
    end
  end

  def down
    remove_column :context_image, :evidence_count
  end
end
