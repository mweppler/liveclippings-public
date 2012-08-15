class UserMailer < ActionMailer::Base
  default :from => "support@yoursite.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def forgot_password user
    @user = user
    mail :to => user.email, :subject => "Reset your LiveClippings Password"
  end
end
