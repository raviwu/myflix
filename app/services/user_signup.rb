class UserSignup
  attr_reader :user, :status, :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invitation_token = nil)
    if user.valid?
      charge = StripeWrapper::Charge.create(
        :amount => 999,
        :source => stripe_token,
        :description => "Registration Charge for #{user.email}")
      if charge.successful?
        user.save
        handle_invitated_registration(invitation_token)
        AppMailer.delay.welcome_new_user(user)
        @status = :success
        self
      else
        @status = :failed
        @error_message = charge.error_message
        self
      end
    else
      @status = :failed
      @error_message = "Invalid user information. Please fix the errors below."
      self
    end
  end

  def successful?
    status == :success
  end

  def handle_invitated_registration(invitation_token)
    if invitation_token.present?
      invitation = Invitation.find_by(token: invitation_token)
      user.follow(invitation.invitor)
      invitation.invitor.follow(user)
      invitation.update_column(:token, nil)
    end
  end
end
