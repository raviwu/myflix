class ForgotPasswordsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user.nil?
      flash[:danger] = params[:email].blank? ? 'Email cannot be blank.' : 'Something wrong with you email.'
      redirect_to forgot_password_path
    else
      AppMailer.delay.reset_password_email(@user)
      redirect_to confirm_password_reset_path
    end
  end
end
