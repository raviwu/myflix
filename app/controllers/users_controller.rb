class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    redirect_to home_path if logged_in?
    @user = User.new
    @prefilled_email = params[:email]
    @prefilled_fullname = params[:fullname]
    @referor_email = params[:referor_email]
  end

  def create
    @user = User.new(user_params)
    if @user.save
      AppMailer.welcome_new_user(@user).deliver
      flash[:success] = "Welcome, #{@user.fullname}"
      log_in(@user)

      follow_and_followed_by_referor

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
    params.require(:user).permit(:email, :fullname, :password, :referor_email)
  end

  def follow_and_followed_by_referor
    referor = User.find_by(email: user_params[:referor_email]) || nil

    current_user.follow(referor) if referor
    referor.follow(current_user) if referor && referor.can_follow?(current_user)
  end
end
