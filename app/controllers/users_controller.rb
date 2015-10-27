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
    if @user.save
      handle_invitated_registration
      Stripe.api_key = Rails.env.production? ?  ENV['STRIPE_LIVE_SECRET_KEY'] : 'sk_test_2gB1xh7jwrowOkemhCZrhR4N'
      token = params[:stripeToken]
      begin
        charge = Stripe::Charge.create(
          :amount => 999,
          :currency => "usd",
          :source => token,
          :description => "Registration Charge for #{@user.email}"
        )
        AppMailer.delay.welcome_new_user(@user)
        flash[:success] = "Welcome, #{@user.fullname}"
        log_in(@user)
        redirect_to home_path
      rescue Stripe::CardError => e
        flash[:danger] = e.message
        render 'new'
      end
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
