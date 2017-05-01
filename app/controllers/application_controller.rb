class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  #layout 'blacklight'

  def layout_name
    "application"
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to main_app.root_url, :alert => exception.message }
    end
  end

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, :except => [:show, :index]

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :institution, :email, :admin, :full_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :institution, :email, :full_name])
  end

end
