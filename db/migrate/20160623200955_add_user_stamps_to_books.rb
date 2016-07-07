require 'securerandom'
class AddUserStampsToBooks < ActiveRecord::Migration
  def get_user
    pass = SecureRandom.hex

    User.find_or_create_by(username: 'LauraAy') do |user|
      user.password              = pass
      user.password_confirmation = pass
      user.email                 = 'aydel@upenn.edu'
      user.full_name             = 'Laura Aydelotte'
      user.admin                 = true
    end
  end

  def change
    add_column :books, :created_by_id, :integer
    add_column :books, :updated_by_id, :integer

    user = get_user
    Book.update_all created_by_id: user.id, updated_by_id: user.id
  end
end
