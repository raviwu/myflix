require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do
    it "renders show template if toke valid" do
      alice = Fabricate(:user)
      get :show, id: alice.token
      expect(response).to render_template(:show)
    end
    it "redirect to expired if token invalid" do
      get :show, id: 'random'
      expect(response).to redirect_to(expired_token_path)
    end
    it "sets @token" do
      alice = Fabricate(:user)
      get :show, id: alice.token
      expect(assigns(:token)).to eq(alice.token)
    end
  end

  describe "POST create" do
    context "with valid token" do
      let(:alice) { Fabricate(:user, password: 'old_password') }
      let(:token) { alice.token }
      before do
        post :create, token: token, password: 'new_password'
      end
      it "redirects to sign_in_path" do
        expect(response).to redirect_to(sign_in_path)
      end
      it "should update user password" do
        expect(alice.reload.authenticate('new_password')).to be_truthy
      end
      it "sets flash[:success]" do
        expect(flash[:success]).to be_present
      end
      it "regenerate user token" do
        expect(alice.reload.token).not_to eq(token)
      end
    end
    context "with invalid token" do
      it "redirect to expired token path" do
        post :create, token: '12345', password: 'new_password'
        expect(response).to redirect_to(expired_token_path)
      end
    end
  end
end
