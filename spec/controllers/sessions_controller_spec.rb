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
    context "with valid input" do
      before do
        post :create, email: user.email, password: "password"
      end
      it "redirects to home_path if authentication succeeds" do
        response.should redirect_to(home_path)
      end
      it "sets the flash[:success]" do
        expect(flash[:success]).not_to be_blank
      end
    end

    context "with invalid input" do
      before do
        post :create, email: user.email, password: "pw"
      end
      it "redirects to sign_in_path if authentication fails" do
        response.should redirect_to(sign_in_path)
      end
      it "sets the flash[:danger]" do
        expect(flash[:danger]).not_to be_blank
      end
    end
  end

  describe "DELETE destroy" do
    before do
      session[:user_id] = user.id
      delete :destroy
    end
    it "clear the session[:user_id]" do
      expect(session[:user_id]).to be_nil
    end
    it "redirects to root_path" do
      response.should redirect_to(root_path)
    end
    it "sets the flash[:info]" do
      expect(flash[:info]).not_to be_blank
    end
  end
end
