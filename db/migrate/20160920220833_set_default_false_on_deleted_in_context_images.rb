class SetDefaultFalseOnDeletedInContextImages < ActiveRecord::Migration
  def up
    ContextImage.update_all deleted: false
    # change_column_default(:suppliers, :qualification, 'new')
    change_column_default :context_images, :deleted, false
  end

  def down
    change_column_default :context_images, :deleted, nil
  end
end
