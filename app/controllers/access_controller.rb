class AccessController < ApplicationController

  layout 'public'

  # before_filter :confirm_logged_in, :only => [:index, :menu]
  before_filter :confirm_logged_in, :except => [:login, :attempt_login, :logout]

  def attempt_login
    authorized_user = User.authenticate(params[:username], params[:password])
    if authorized_user
      session[:user_id] = authorized_user.id
      session[:username] = authorized_user.username
      flash[:notice] = "You are now logged in."
      redirect_to(:controller => 'clippings', :action => 'list')
    else
      flash[:notice] = "Invalid username/password combination"
      redirect_to(:action => 'login')
    end
  end

  def login
    # just display the login form
  end

  def logout
    session[:user_id] = nil
    session[:username] = nil
    flash[:notice] = "You are now logged out"
    redirect_to(:action => 'login')
  end

end