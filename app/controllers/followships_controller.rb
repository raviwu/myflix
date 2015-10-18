class FollowshipsController < ApplicationController
  before_action :require_user

  def index
  end

  def create
    followee = User.find(params[:followee])
    if current_user.can_follow?(followee)
      current_user.follow(followee)
      flash[:success] = "Successfully follow #{followee.fullname}"
      redirect_to people_path
    else
      access_deny
      redirect_to user_path(followee)
    end
  end

  def destroy
    followee = Followship.find(params[:id]).followee
    if current_user.followed?(followee)
      current_user.unfollow(followee)
      flash[:success] = "Successfully unfollow #{followee.fullname}."
    else
      access_deny
    end
    redirect_to people_path
  end
end
