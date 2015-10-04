require 'spec_helper'

describe SessionsController do
  let(:user) { Fabricate(:user) }

  describe "GET new" do
    it "redirect_to home_path if there is current_user" do
      session[:user_id] = user.id
      get :new
      response.should redirect_to(home_path)
    end
    it "renders the new template" do
      get :new
      response.should render_template :new
    end
  end

  describe "POST create" do
    it "redirects to home_path if authentication succeeds" do
      post :create, email: user.email, password: "password"
      response.should redirect_to(home_path)
    end
    it "redirects to sign_in_path if authentication fails" do
      post :create, email: user.email, password: "pw"
      response.should redirect_to(sign_in_path)
    end
  end

  describe "DELETE destroy" do
    it "clear the session[:user_id]" do
      delete :destroy
      expect(session[:user_id]).to be_falsey
    end
    it "redirects to root_path" do
      delete :destroy
      response.should redirect_to(root_path)
    end
  end
end
