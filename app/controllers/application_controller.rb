class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  protected

  def confirm_logged_in
    unless session[:user_id]
      flash[:notice] = "Please sign in."
      redirect_to(:controller => 'access', :action => 'login')
      return false # halts the before_filter
    else
      return true
    end
  end

  private

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

end