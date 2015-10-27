require 'spec_helper'

describe FollowshipsController do

  describe "GET index" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end

    context "logged in user and follow new user" do
      let(:joe) { Fabricate(:user) }

      before do
        set_current_user
        post :create, followee: joe.id
      end

      it "creates folllowships between current_user and followee" do
        expect(current_user.followed?(joe)).to be_truthy
      end

      it "sets flash[:success]" do
        expect(flash[:success]).to be_present
      end

      it "redirects to people_path" do
        expect(response).to redirect_to(people_path)
      end
    end

    context "logged in user and follow the followed user" do
      let(:joe) { Fabricate(:user) }

      before do
        set_current_user
        current_user.follow(joe)
        post :create, followee: joe.id
      end

      it "does not create new followship record" do
        expect(Followship.all.size).to eq(1)
      end

      it "sets flash[:danger]" do
        expect(flash[:danger]).to be_present
      end

      it "redirects to user path" do
        expect(response).to redirect_to(user_path(joe))
      end
    end

    it "does not allow one to follow themselves" do
      set_current_user
      post :create, followee: current_user.id
      expect(Followship.all.size).to eq(0)
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "require_sign_in" do
      let(:action) { delete :destroy, id: 1 }
    end

    context "logged in and do follow the followee" do
      let(:followee) { Fabricate(:user) }

      before do
        set_current_user
        current_user.follow(followee)
        followship = Followship.where(follower: current_user, followee: followee).first
        delete :destroy, id: followship.id
      end

      it "deletes the followship" do
        expect(current_user.followed?(followee)).to be_falsey
      end

      it "sets the flash[:success]" do
        expect(flash[:success]).to be_present
      end

      it "redirect to people_path" do
        expect(response).to redirect_to(people_path)
      end
    end

    context "logged in but not the follower in followship" do
      let(:followee) { Fabricate(:user) }
      let(:followship) { Fabricate(:followship) }

      before do
        set_current_user
        delete :destroy, id: followship.id
      end

      it "does not delete the followship" do
        expect(followship).to be_truthy
      end
      
      it "redirects to root_path" do
        expect(response).to redirect_to(people_path)
      end
    end
  end
end
