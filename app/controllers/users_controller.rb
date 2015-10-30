class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    if logged_in?
      redirect_to home_path
      return
    end
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
    result = UserSignup.new(@user).sign_up(params[:stripeToken], params[:user][:invitation_token])
    if result.successful?
      flash[:success] = "Welcome, #{@user.fullname}"
      log_in(@user)
      redirect_to home_path
    else
      flash.now[:danger] = result.error_message
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

end
