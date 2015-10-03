class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      flash[:success] = "Welcome back, #{@user.fullname}."
      log_in(@user)
      redirect_to home_path
    else
      flash[:danger] = "Wrong email / password combination."
      render 'new'
    end
  end

  def destroy
    log_out(current_user)
    redirect_to root_path
  end
end
