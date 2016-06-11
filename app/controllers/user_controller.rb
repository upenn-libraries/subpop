class UserController < ApplicationController
  before_action :set_user, except: [:index, :new, :create]

  authorize_resource

  def index
    @users = User.all.order('username').page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Successfully created user '#{@user.username}'."
      redirect_to user_index_path
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    params_temp = user_params
    params_temp.delete(:password) if params_temp[:password].blank?
    if params_temp[:password].blank? && params_temp[:password_confirmation].blank?
      params_temp.delete(:password_confirmation)
    end

    if @user.update_attributes(params_temp)
      flash[:notice] = "Successfully updated user '#{@user.username}'."
      redirect_to user_index_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user.soft_delete
    flash[:notice] = "Cancelled account '#{@user.username}'."
    redirect_to user_index_path
  end

  private
  def set_user
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user).permit(:username, :email, :admin, :password, :password_confirmation, :restore_account)
  end
end