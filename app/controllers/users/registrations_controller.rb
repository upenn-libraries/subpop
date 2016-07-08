# Following Devise Wiki instructions for soft_deleting a user, rather than the
# default devise behavior which is to destroy the account. We can't do delete
# the records because we will record the user ID information with the records
# they create and modify.
#
# https://github.com/plataformatec/devise/wiki/How-to:-Soft-delete-a-user-when-user-deletes-account
#
class Users::RegistrationsController < Devise::RegistrationsController
  # DELETE /resource
  def destroy
    resource.soft_delete
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message! :notice, :destroyed
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end
end