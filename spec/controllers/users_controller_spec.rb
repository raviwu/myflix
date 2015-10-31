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

    context "successful user sign up" do
      before do
        result = double(:sign_up_result, successful?: true)
        expect_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
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
    end

    context "failed user sign up" do
      before do
        result = double(:sign_up_result, successful?: false, error_message: "errors")
        expect_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: invalid_user_params, stripeToken: '12345'
      end

      it "renders the new template" do
        expect(response).to render_template(:new)
      end

      it "sets flash[:danger]" do
        expect(flash[:danger]).to be_present
      end

      it "does not send out email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "does not create user" do
        expect(User.all.size).to eq(0)
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
