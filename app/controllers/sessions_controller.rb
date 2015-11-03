class SessionsController < ApplicationController
  def new
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      if user.active?
        flash[:success] = "Welcome back, #{user.fullname}. Enjoy!"
        log_in(user)
        redirect_to home_path
      else
        flash.now[:danger] = "Your account has been suspended, please contact customer services."
        render :new
      end
    else
      flash[:danger] = "Invalid email / password combination."
      redirect_to sign_in_path
    end
  end

  def destroy
    log_out(current_user)
    flash[:info] = "You've logged out!"
    redirect_to root_path
  end
end
