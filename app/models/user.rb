class User < ActiveRecord::Base

  PASSWORD_RE = /^(?=.*[[:alnum:]])(?=.*[_!#$%&\/()=?+*~^\[\]{}:-])/
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable,
    :rememberable, :trackable, :validatable,
    :registerable

  # local attribute for account restoration
  attr_accessor :restore_account

  cattr_accessor :excluded_names

  before_save :undelete,  if: :restore_account?

  validates :username, presence: true, uniqueness: true
  validate :excluded_user_names
  validate :password_complexity

  # TODO exclude usernames 'all', 'admin', ???

  scope :by_name, -> { order("coalesce(full_name, username)") }

  def display_name
    return full_name if full_name.present?

    username
  end

  # instead of deleting, indicate the user requested a delete & timestamp it
  def soft_delete
    update_attribute(:deleted_at, Time.current)
  end

  # restore the account
  def undelete
    self.deleted_at = nil
  end

  def restore_account?
    @restore_account.present?
  end

  # ensure user account is active
  def active_for_authentication?
    super && !deleted_at
  end

  # provide a custom message for a deleted account
  def inactive_message
    !deleted_at ? super : :deleted_account
  end

  def excluded_user_names
    return unless username.present?
    return unless excluded_names.present?
    return unless excluded_names.include? username.strip.downcase

    errors.add :username, 'is not allowed'
  end

  def password_complexity
    return if password.blank?
    return if password.size > 20
    return if password.match PASSWORD_RE

    errors.add :password, "complexity requirement not met"
  end

end
