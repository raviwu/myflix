require 'spec_helper'

describe UsersController do

  describe "GET new" do
    it "redirect_to home_path if there is current_user" do
      set_current_user
      get :new
      response.should redirect_to(home_path)
    end
    it "sets the @user variable if there is no current_user" do
      get :new
      assigns(:user).should be_new_record
      assigns(:user).should be_instance_of(User)
    end
    it "renders the new template" do
      get :new
      response.should render_template :new
    end
  end

  describe "POST create" do
    let(:valid_user_params) { {
      email: "test@example.com",
      fullname: "user",
      password: "password"} }

    let(:invalid_user_params) { {
      fullname: "user",
      password: "pw"} }
    context "with valid user input" do
      before do
        post :create, user: valid_user_params
      end
      it "sets the @user variable" do
        assigns(:user).should be_instance_of(User)
      end
      it "saves the @user" do
        user = User.find_by(email: valid_user_params[:email])
        expect(User.last).to eq(user)
      end
      it "sets the flash notice" do
        expect(flash[:success]).not_to be_blank
      end
      it "redirects to home_path if the record is saved" do
        response.should redirect_to(home_path)
      end
    end

    it "renders the new template if the input params is invalid" do
      post :create, user: invalid_user_params
      response.should render_template :new
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
