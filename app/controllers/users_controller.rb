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
      @user.add_referor(user_params[:referor_email])
      AppMailer.welcome_new_user(@user).deliver
      flash[:success] = "Welcome, #{@user.fullname}"
      log_in(@user)
      create_mutual_followships_with_referor if current_user.referor
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

  def create_mutual_followships_with_referor
    current_user.followees << current_user.referor
    current_user.followers << current_user.referor
  end
end
