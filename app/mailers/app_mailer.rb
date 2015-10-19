class AppMailer < ActionMailer::Base
  def welcome_new_user(user)
    @user = user
    mail from: 'noreply@myflixapp.com', to: user.email, subject: 'Thank you for registrate MyFLix account.'
  end

  def reset_password_email(user)
    @user = user
    mail from: 'noreply@myflixapp.com', to: user.email, subject: 'Reset your MyFLix password'
  end
end
