require 'spec_helper'

describe UsersController do
  let(:valid_user_params) { {email: "test@example.com", fullname: "user", password: "password"} }
  let(:invalid_user_params) { {fullname: "user", password: "pw"} }

  describe "GET new" do
    it "redirect_to home_path if there is current_user" do
      user = User.create(valid_user_params)
      session[:user_id] = user.id
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
    it "sets the @user variable with input params" do
      post :create, user: valid_user_params
      assigns(:user).should be_instance_of(User)
    end
    it "saves the @user if input params is valid" do
      post :create, user: valid_user_params
      user = User.find_by(email: valid_user_params[:email])
      expect(User.last).to eq(user)
    end
    it "redirects to home_path if the record is saved" do
      post :create, user: valid_user_params
      response.should redirect_to(home_path)
    end
    it "renders the new template if the input params is invalid" do
      post :create, user: invalid_user_params
      response.should render_template :new
    end
  end
end
