class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      flash[:success] = "Welcome back, #{@user.fullname}."
      # login user
      # redirect_to user_path(@user)
    else
      flash[:danger] = "Wrong email / password combination."
      render 'new'
    end
  end
end
