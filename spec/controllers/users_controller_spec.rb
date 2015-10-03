require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "redirect_to home_path if there is current_user" do
      user = User.create(email: "user@example.com", fullname: "user", password: "password")
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
      post :create, user: {email: "test@example.com", fullname: "user", password: "password"}
      assigns(:user).should be_instance_of(User)
    end
    it "saves the @user if input params is valid" do
      post :create, user: {email: "test@example.com", fullname: "user", password: "password"}
      user = User.find_by(email: "test@example.com")
      expect(User.last).to eq(user)
    end
    it "redirects to home_path if the record is saved" do
      post :create, user: {email: "test@example.com", fullname: "user", password: "password"}
      response.should redirect_to(home_path)
    end
    it "renders the new template if the input params is invalid" do
      post :create, user: {fullname: "user", password: "pw"}
      response.should render_template :new
    end
  end
end
