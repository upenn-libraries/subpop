class ChangeNameCommentType < ActiveRecord::Migration

  change_column :names, :comment, :text

end
