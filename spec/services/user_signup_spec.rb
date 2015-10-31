require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    let(:valid_user) { User.new(
      email: "test@example.com",
      fullname: "valid_user",
      password: "password") }

    let(:invalid_user) { User.new(
      email: "invalid@example",
      fullname: "invalid_user",
      password: "pw") }

    context "with valid user input and valid card" do
      before do
        charge = double(:charge, successful?: true)
        expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
        UserSignup.new(valid_user).sign_up("fake_stripe_token")
      end

      it "sends out the email" do
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "sends to correct recipient" do
        mail = ActionMailer::Base.deliveries.last
        expect(mail.to).to eq(['test@example.com'])
      end

      it "contains correct content" do
        mail = ActionMailer::Base.deliveries.last
        expect(mail.body).to include('Welcome, valid_user.')
      end
    end

    context "with valid user input and invalid card" do
      it "does not create a new user" do
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
        UserSignup.new(valid_user).sign_up("fake_stripe_token")
        expect(User.all.size).to eq(0)
      end
    end

    context "with invalid user input and invalid card" do
      before do
        UserSignup.new(invalid_user).sign_up("fake_stripe_token")
      end
      it "does not charge the card" do
        expect(StripeWrapper::Charge).not_to receive(:create)
      end
    end

    context "with invitation token and valid input" do
      let(:joe) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, invitor: joe, recipient_fullname: 'Alice', recipient_email: 'alice@exapmle.com') }

      before do
        charge = double(:charge, successful?: true)
        expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
        UserSignup.new(valid_user).sign_up("fake_stripe_token", invitation.token)
      end

      it "sets the new user follow the invitor" do
        alice = User.last
        expect(alice.followed?(joe)).to be_truthy
      end

      it "sets the invitor follow the new user" do
        alice = User.last
        expect(joe.followed?(alice)).to be_truthy
      end

      it "expired the invitation token" do
        expect(Invitation.last.token).to be_nil
      end
    end
  end
end
