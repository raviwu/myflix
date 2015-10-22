class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    redirect_to home_path if logged_in?
    @user = User.new
  end

  def new_with_invitation_token
    if logged_in?
      redirect_to home_path
      return
    end
    @invitation = Invitation.find_by(token: params[:token])
    if @invitation
      @user = User.new(fullname: @invitation.recipient_fullname, email: @invitation.recipient_email)
    else
      redirect_to expired_invitation_token_path
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      handle_invitated_registration
      AppMailer.welcome_new_user(@user).deliver
      flash[:success] = "Welcome, #{@user.fullname}"
      log_in(@user)
      redirect_to home_path
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email, :fullname, :password)
  end

  def handle_invitated_registration
    if params[:user][:invitation_token].present?
      @invitation = Invitation.find_by(token: params[:user][:invitation_token])
      @user.follow(@invitation.invitor)
      @invitation.invitor.follow(@user)
      @invitation.token = nil
    end
  end

end
