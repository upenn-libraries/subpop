# A concern for model classes that have created_by and updated_by fields
# Swiped wholesale from the new SDBM code:
#
#   https://github.com/upenn-libraries/sdbmss/blob/master/app/models/concerns/user_fields.rb
module UserFields

  extend ActiveSupport::Concern

  included do
    belongs_to :created_by, class_name: 'User'
    belongs_to :updated_by, class_name: 'User'

    delegate :username, to: :created_by, prefix: true, allow_nil: true
    delegate :username, to: :updated_by, prefix: true, allow_nil: true
  end

  # Note that `#save_by` invokes `#save`, which does not take attributes.
  def save_by(user, *args, &block)
    self.created_by = user if !persisted?
    self.updated_by = user

    save *args, &block
  end

  # Note that `#save_by!` invokes `#save!`, which does not take attributes.
  def save_by!(user, *args, &block)
    self.created_by = user if !persisted?
    self.updated_by = user

    save! *args, &block
  end

  # Note that `#updated_by` invokes `#update`, which requires an `attributes`
  # argument.
  def update_by(user, attributes, &block)
    self.updated_by = user
    update attributes, &block
  end

  # Note that `#updated_by` invokes `#update`, which requires an `attributes`
  # argument.
  def update_by!(user, attributes, &block)
    self.updated_by = user
    update! attributes, &block
  end
end