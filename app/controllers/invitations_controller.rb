class InvitationsController < AuthenticatedController

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.invitor = current_user
    if @invitation.save
      AppMailer.delay.invite_user(@invitation)
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
