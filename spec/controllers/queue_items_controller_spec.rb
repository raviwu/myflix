require 'spec_helper'

describe QueueItemsController do
  let(:user) { Fabricate(:user) }
  let(:video) { Fabricate(:video) }

  describe "GET index" do
    it "redirects to sign_in_path when not logged in" do
      get :index
      response.should redirect_to(sign_in_path)
    end

    it "sets the @queue_items" do
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user: user)
      queue_item2 = Fabricate(:queue_item, user: user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
  end

  describe "POST create" do
    it "redirects to sign_in_path when not logged in" do
      post :create, id: video.id
      response.should redirect_to(sign_in_path)
    end

    context "current_user queued the video" do
      before do
        session[:user_id] = user.id
        queue_item1 = Fabricate(:queue_item, user: user, video: video)
        post :create, id: video.id
      end
      it "sets the @queue_item variable" do
        assigns(:queue_item).should be_instance_of(QueueItem)
      end
      it "creates the @queue_item associated with video" do
        expect(assigns(:queue_item).video).to eq(video)
      end
      it "creates the @queue_item associated with user" do
        expect(assigns(:queue_item).user).to eq(user)
      end
      it "does not save the same queue_item" do
        expect(QueueItem.all.count).to eq(1)
      end
      it "set the flash[:danger] if found same record" do
        expect(flash[:danger]).not_to be_nil
      end
      it "redirects to video show page if the queue is not saved" do
        response.should redirect_to video_path(video)
      end
    end

    context "current_user not yet queue the video" do
      before do
        session[:user_id] = user.id
        Fabricate(:queue_item, user: user, position: 1)
        Fabricate(:queue_item, user: user, position: 2)
        post :create, id: video.id
      end
      it "saves @queue_item if there's no same queue_item record found" do
        expect(user.queue_items.count).to eq(3)
      end
      it "saves @queue_item as last record in position" do
        expect(user.queue_items.last.video).to eq(video)
      end
      it "sets the flash[:success]" do
        expect(flash[:success]).not_to be_nil
      end
      it "redirect to my_queue_path after the queue_item is saved" do
        response.should redirect_to my_queue_path
      end
    end
  end

  describe "PUT/PATCH update_position" do
    let(:queue_item1) { Fabricate(:queue_item, user: user, position: 1) }
    let(:queue_item2) { Fabricate(:queue_item, user: user, position: 2) }

    let(:valid_params) { {queue_item1.id => {position: '2'}, queue_item2.id => {position: '1'}} }
    let(:valid_params_incorrect_order) { {queue_item1.id => {position: '2'}, queue_item2.id => {position: '3'}} }
    let(:non_integer_params) { {queue_item1.id => {position: 'a'}, queue_item2.id => {position: '1'}} }
    let(:dup_position_params) { {queue_item1.id => {position: '1'}, queue_item2.id => {position: '1'}} }

    it "redirect to sign_in_path if not logged in" do
      put :update_position
      response.should redirect_to sign_in_path
    end
    context "logged in but not the queue items owner" do
      before do
        session[:user_id] = Fabricate(:user).id
        put :update_position, queue_items: valid_params
      end
      it "redirect to my_queue_path of not authenticated user" do
        response.should redirect_to my_queue_path
      end
      it "sets flash[:danger]" do
        expect(flash[:danger]).not_to be_nil
      end
    end
    context "logged in with authenticated user" do
      before do
        session[:user_id] = user.id
      end
      it "does not save if the postition input is not integer" do
        put :update_position, queue_items: non_integer_params
        expect(queue_item1.position).to eq(1)
      end
      it "does not save if the postition input has duplication" do
        put :update_position, queue_items: dup_position_params
        expect(queue_item1.position).to eq(1)
      end
      it "updates the queur items according to correct input" do
        put :update_position, queue_items: valid_params
        expect(queue_item1.reload.position).to eq(2)
      end
      it "normalize the position order" do
        put :update_position, queue_items: valid_params_incorrect_order
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end

  describe "DELETE destroy" do
    it "redirects to sign_in_path when not logged in" do
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      response.should redirect_to(sign_in_path)
    end
    context "logged in but not queue owner" do
      before do
        session[:user_id] = user.id
        queue_item = Fabricate(:queue_item, user: Fabricate(:user), video: video)
        delete :destroy, id: queue_item.id
      end
      it "redirects to root_path when current_user is not queue item owner" do
        response.should redirect_to(root_path)
      end
      it "sets flash[:danger] when current_user is not queue item owner" do
        expect(flash[:danger]).not_to be_nil
      end
    end
    context "with authenticated user" do
      before do
        session[:user_id] = user.id
        Fabricate(:queue_item, user: user, position: 1)
        queue_item = Fabricate(:queue_item, user: user, video: video, position: 2)
        Fabricate(:queue_item, user: user, position: 3)
        delete :destroy, id: queue_item.id
      end
      it "deletes the record" do
        expect(user.queue_items.count).to eq(2)
      end
      it "normalize the remaining queue items" do
        expect(user.queue_items.last.position).to eq(2)
      end
      it "redirect to my_queue_path" do
        response.should redirect_to(my_queue_path)
      end
    end
  end
end
