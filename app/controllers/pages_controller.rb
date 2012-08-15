class PagesController < ApplicationController

  layout 'public'

  def about
  end

  def contact
  end

  def forgot_password
    unless params[:email].nil?
      user = User.find_by_email(params[:email])
      user.send_password_reset if user
      redirect_to root_url, :notice => "An email with instructions on resetting your password has been sent."
    end
  end

  def help
  end

  def home
      if current_user
          redirect_to(:controller => 'clippings', :action => 'list')
      end
  end

  def password_reset
    unless params[:user].nil?
      @user = User.find_by_password_reset_token!(params[:id])
      if @user.password_reset_sent_at < 2.hours.ago
        redirect_to 'forgot_password', :alert => "Password reset has expired."
      end
      @user.password_reset_token = nil
      @user.password_reset_sent_at = nil
      if @user.update_attributes(params[:user])
        redirect_to '/signin', :notice => "Password has been reset!"
      else
        render :password_reset
      end
    end
  end

end
