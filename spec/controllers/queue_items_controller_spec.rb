require 'spec_helper'

describe QueueItemsController do
  let(:video) { Fabricate(:video) }

  describe "GET index" do
    it_behaves_like "require_sign_in" do
      let(:action) {get :index}
    end

    it "sets the @queue_items" do
      set_current_user
      queue_item1 = Fabricate(:queue_item, user: current_user)
      queue_item2 = Fabricate(:queue_item, user: current_user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
  end

  describe "POST create" do

    it_behaves_like "require_sign_in" do
      let(:action) {post :create, id: video.id}
    end

    context "current_user queued the video" do
      before do
        set_current_user
        queue_item1 = Fabricate(:queue_item, user: current_user, video: video)
        post :create, id: video.id
      end
      it "sets the @queue_item variable" do
        expect(assigns(:queue_item)).to be_instance_of(QueueItem)
      end
      it "creates the @queue_item associated with video" do
        expect(assigns(:queue_item).video).to eq(video)
      end
      it "creates the @queue_item associated with user" do
        expect(assigns(:queue_item).user).to eq(current_user)
      end
      it "does not save the same queue_item" do
        expect(QueueItem.all.count).to eq(1)
      end
      it "set the flash[:danger] if found same record" do
        expect(flash[:danger]).not_to be_nil
      end
      it "redirects to video show page if the queue is not saved" do
        expect(response).to redirect_to(video_path(video))
      end
    end

    context "current_user not yet queue the video" do
      before do
        set_current_user
        2.times { Fabricate(:queue_item, user: current_user) }
        post :create, id: video.id
      end
      it "saves @queue_item if there's no same queue_item record found" do
        expect(current_user.queue_items.count).to eq(3)
      end
      it "saves @queue_item as last record in position" do
        expect(current_user.queue_items.last.position).to eq(3)
      end
      it "sets the flash[:success]" do
        expect(flash[:success]).to be_present
      end
      it "redirect to my_queue_path after the queue_item is saved" do
        expect(response).to redirect_to(my_queue_path)
      end
    end
  end

  describe "PUT/PATCH update_position" do
    let(:user) { Fabricate(:user) }
    let(:queue_item1) { Fabricate(:queue_item, user: user, position: 1) }
    let(:queue_item2) { Fabricate(:queue_item, user: user, position: 2) }

    let(:valid_params) { {
      queue_item1.id.to_s => {position: '2'}, queue_item2.id.to_s => {position: '1'}} }
    let(:valid_params_with_rating) { {
      queue_item1.id.to_s => {position: '2', rating: '2'}, queue_item2.id.to_s => {position: '1', rating: ''}} }
    let(:valid_params_incorrect_order) { {
      queue_item1.id.to_s => {position: '2'}, queue_item2.id.to_s => {position: '3'}} }
    let(:non_integer_params) { {
      queue_item1.id.to_s => {position: 'a'}, queue_item2.id.to_s => {position: '1'}} }
    let(:dup_position_params) { {
      queue_item1.id.to_s => {position: '1'}, queue_item2.id.to_s => {position: '1'}} }

    it_behaves_like "require_sign_in" do
      let(:action) { put :update_position }
    end

    context "logged in but not the queue items owner" do
      before do
        session[:user_id] = Fabricate(:user).id
        put :update_position, queue_items: valid_params
      end
      it "redirect to my_queue_path of not authenticated user" do
        expect(response).to redirect_to(my_queue_path)
      end
      it "sets flash[:danger]" do
        expect(flash[:danger]).to be_present
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
      it "update if setting nil to existing rating" do
        queue_item2.video.reviews.create(creator: user, rating: 5)
        put :update_position, queue_items: valid_params_with_rating
        expect(queue_item2.rating).to eq(nil)
      end
      it "update the existed rating" do
        queue_item1.video.reviews.create(creator: user, rating: 5)
        put :update_position, queue_items: valid_params_with_rating
        expect(queue_item1.rating).to eq(2)
      end
      it "creates review if there's no existed review" do
        put :update_position, queue_items: valid_params_with_rating
        expect(queue_item1.rating).to eq(2)
      end
      it "does not create review if rating input is nil" do
        put :update_position, queue_items: valid_params_with_rating
        expect(Review.where(creator: user, video: queue_item2.video).first).to be_nil
      end
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "require_sign_in" do
      let(:action) {
        queue_item = Fabricate(:queue_item)
        delete :destroy, id: queue_item.id
      }
    end

    context "logged in but not queue owner" do
      before do
        set_current_user
        queue_item = Fabricate(:queue_item, user: Fabricate(:user))
        delete :destroy, id: queue_item.id
      end
      it "redirects to root_path when current_user is not queue item owner" do
        expect(response).to redirect_to(root_path)
      end
      it "sets flash[:danger] when current_user is not queue item owner" do
        expect(flash[:danger]).to be_present
      end
    end
    context "with authenticated user" do
      before do
        set_current_user
        Fabricate(:queue_item, user: current_user, position: 1)
        queue_item = Fabricate(:queue_item, user: current_user, position: 2)
        Fabricate(:queue_item, user: current_user, position: 3)
        delete :destroy, id: queue_item.id
      end
      it "deletes the record" do
        expect(current_user.queue_items.count).to eq(2)
      end
      it "normalize the remaining queue items" do
        expect(current_user.queue_items.last.position).to eq(2)
      end
      it "redirect to my_queue_path" do
        expect(response).to redirect_to(my_queue_path)
      end
    end
  end
end
