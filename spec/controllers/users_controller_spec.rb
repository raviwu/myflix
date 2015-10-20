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
      assigns(:user).should be_new_record
      assigns(:user).should be_instance_of(User)
    end
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    let(:valid_user_params) { {
      email: "test@example.com",
      fullname: "valid_user",
      password: "password",
      referor_email: nil} }

    let(:valid_user_params_with_referor) { {
      email: "test@example.com",
      fullname: "valid_user",
      password: "password",
      referor_email: Fabricate(:user, email: 'existed@user.com').email } }

    let(:invalid_user_params) { {
      email: "invalid@example",
      fullname: "invalid_user",
      password: "pw",
      referor_email: nil} }
    context "with valid user input" do
      before { post :create, user: valid_user_params }
      after { ActionMailer::Base.deliveries.clear }
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

    context "with invalid input" do
      before { post :create, user: invalid_user_params }
      after { ActionMailer::Base.deliveries.clear }
      it "renders the new template" do
        expect(response).to render_template(:new)
      end
      it "does not send out email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "with referor" do
      before do
        post :create, user: valid_user_params_with_referor
      end
      it "creates mutual followships between user and referor" do
        expect(assigns(:user).followers).to include(assigns(:user).referor)
        expect(assigns(:user).followees).to include(assigns(:user).referor)
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
