class InviteUsersController < ApplicationController
  before_action 'require_user'

  def new
  end

  def create
    email = params[:email]
    fullname = params[:fullname]
    message = params[:message]
    if email.blank? || fullname.blank?
      flash[:danger] = "Email cannot be blank."
      render :new
    else
      AppMailer.invite_user(current_user, email, fullname, message).deliver
      flash[:success] = "You've successfully invite #{fullname} to join MyFlix!"
      redirect_to home_path
    end
  end
end
