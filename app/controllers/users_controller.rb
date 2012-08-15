
require 'digest/md5'

class UsersController < ApplicationController

  layout 'public'

  before_filter :confirm_logged_in, :except => [:new, :create]

  def create
    params[:user][:email]     = params[:user][:email].strip.downcase
    params[:user][:username]  = params[:user][:username].strip.downcase
    params[:user][:user_hash] = Digest::MD5.hexdigest(params[:user][:email])
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "User Created"
      redirect_to(:controller => 'access', :action => 'login')
    else
      render('new')
    end
  end

  def delete
    @user = User.find_by_id(current_user.id)
  end

  def destroy
    User.find_by_id(current_user.id).destroy
    flash[:notice] = "Profile Deleted"
    redirect_to(:controller => 'access', :action => 'logout')
  end

  def edit
    @user = User.find_by_id(current_user.id)
  end

  def new
    @user = User.new
  end

  def view_profile
    # new feature to be implemented.
  end

  def show
    @user = User.find_by_id(current_user.id)
  end

  def update
    @user = User.find_by_id(current_user.id)
    params[:user][:email]     = params[:user][:email].strip.downcase
    params[:user][:username]  = params[:user][:username].strip.downcase
    params[:user][:user_hash] = Digest::MD5.hexdigest(params[:user][:email])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Profile Updated"
      redirect_to(:action => 'show')
    else
      render('edit')
    end
  end

end
