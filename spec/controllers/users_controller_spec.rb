require 'spec_helper'

describe UsersController do

  describe "GET new" do

    it "redirect_to home_path if there is current_user" do
      set_current_user
      get :new
      expect(response).to redirect_to(home_path)
    end

    it "sets the @user variable if there is no current_user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end

  end

  describe "GET new_with_invitation_token" do

    it "redirect_to home_path if there is current_user" do
      set_current_user
      get :new_with_invitation_token, token: "12345"
      expect(response).to redirect_to(home_path)
    end

    context "with valid token" do
      let(:joe) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, invitor: joe, recipient_fullname: 'Alice', recipient_email: 'alice@exapmle.com') }

      before do
        get :new_with_invitation_token, token: invitation.token
      end

      it "sets the @user variable" do
        expect(assigns(:user)).to be_a_new(User)
      end

      it "sets the @invitation variable" do
        expect(assigns(:invitation)).to be_instance_of(Invitation)
      end

      it "match the @user's info with @invitaion recipient info" do
        expect(assigns(:user).fullname).to eq('Alice')
        expect(assigns(:user).email).to eq('alice@exapmle.com')
      end
    end

    context "with invalid token" do
      it "redirect to expired_invitation_token" do
        get :new_with_invitation_token, token: '12345'
        expect(response).to redirect_to(expired_invitation_token_path)
      end
    end
  end

  describe "POST create" do
    let(:valid_user_params) { {
      email: "test@example.com",
      fullname: "valid_user",
      password: "password"} }

    let(:invalid_user_params) { {
      email: "invalid@example",
      fullname: "invalid_user",
      password: "pw"} }

    context "with valid user input and valid card" do
      before do
        charge = double(:charge, successful?: true)
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: valid_user_params, stripeToken: '12345'
      end

      it "sets the @user variable" do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "saves the @user" do
        user = User.find_by(email: valid_user_params[:email])
        expect(User.last).to eq(user)
      end

      it "sets the flash notice" do
        expect(flash[:success]).to be_present
      end

      it "redirects to home_path if the record is saved" do
        expect(response).to redirect_to(home_path)
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

    context "with valid personal info and declined card" do
      before do
        charge = double(:charge, successful?: false, error_message: 'Card declined.')
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: valid_user_params, stripeToken: '12345'
      end

      it "does not create User" do
        expect(User.all.size).to eq(0)
      end

      it "sets flash[:danger]" do
        expect(flash[:danger]).to be_present
      end

      it "render new template" do
        expect(response).to render_template(:new)
      end
    end

    context "with invalid input" do
      before do
        post :create, user: invalid_user_params
      end

      it "renders the new template" do
        expect(response).to render_template(:new)
      end

      it "does not send out email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "does not create user" do
        expect(User.all.size).to eq(0)
      end

      it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
      end

    end

    context "with invitation token and valid input" do
      let(:joe) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, invitor: joe, recipient_fullname: 'Alice', recipient_email: 'alice@exapmle.com') }

      before do
        charge = double(:charge, successful?: true)
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: {
          email: "alice@example.com",
          fullname: "Alice",
          password: "password",
          invitation_token: invitation.token}, stripeToken: '12345'
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
        expect(assigns(:invitation).token).to be_nil
      end
    end
  end

  describe "GET show" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: 1 }
    end

    context "with logged in user" do

      before do
        set_current_user
      end

      it "sets user variable" do
        get :show, id: current_user.id
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "renders user page according to the params[:id]" do
        joe = Fabricate(:user, fullname: 'Joe Doe')
        get :show, id: joe.id
        expect(assigns(:user).fullname).to eq('Joe Doe')
      end
    end
  end
end
