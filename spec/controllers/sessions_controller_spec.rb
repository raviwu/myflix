require 'spec_helper'

describe SessionsController do

  describe "GET new" do
    it "redirect_to home_path if there is current_user" do
      set_current_user
      get :new
      expect(response).to redirect_to(home_path)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    let(:user) { Fabricate(:user, password: 'password') }

    context "with valid input" do
      before do
        post :create, email: user.email, password: "password"
      end

      it "redirects to home_path if authentication succeeds" do
        expect(response).to redirect_to(home_path)
      end

      it "sets the flash[:success]" do
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do
      before do
        post :create, email: user.email, password: "pw"
      end

      it "redirects to sign_in_path if authentication fails" do
        expect(response).to redirect_to(sign_in_path)
      end

      it "sets the flash[:danger]" do
        expect(flash[:danger]).to be_present
      end
    end
  end

  describe "DELETE destroy" do
    before do
      set_current_user
      delete :destroy
    end

    it "clear the session[:user_id]" do
      expect(session[:user_id]).to be_nil
    end

    it "redirects to root_path" do
      expect(response).to redirect_to(root_path)
    end
    
    it "sets the flash[:info]" do
      expect(flash[:info]).to be_present
    end
  end
end
