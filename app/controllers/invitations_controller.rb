class InvitationsController < ApplicationController
  before_action 'require_user'

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.invitor = current_user
    if @invitation.save
      AppMailer.invite_user(@invitation).deliver
      flash[:success] = "You've successfully invite #{@invitation.recipient_fullname} to join MyFlix!"
      redirect_to home_path
    else
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipient_email, :recipient_fullname, :message)
  end
end
