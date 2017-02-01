class AddCommentBookToBooks < ActiveRecord::Migration
  def change
    add_column :books, :comment_book, :text
  end
end
