require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like 'require_sign_in' do
      let(:action) { get :new }
    end
    it_behaves_like 'require_admin' do
      let(:action) { get :new }
    end
    it "sets @video to a new video record with admin" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_new_record
      expect(assigns(:video)).to be_instance_of(Video)
    end
  end

  describe "POST create" do
    it_behaves_like 'require_sign_in' do
      let(:action) { post :create }
    end
    it_behaves_like 'require_admin' do
      let(:action) { post :create }
    end

    context "with valid input" do
      before do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: "Paul", description: "A funny alien movie.", categories: category.id}
      end
      it "redirects to the add new video page" do
        expect(response).to redirect_to(new_admin_video_path)
      end
      it "creates a new video" do
        expect(Category.last.videos.count).to eq(1)
      end
      it "sets the flash[:success]" do
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do
      before do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { description: "A funny alien movie.", categories: category.id}
      end
      it "does not create a video" do
        expect(Category.last.videos.count).to eq(0)
      end
      it "render new template" do
        expect(response).to render_template(:new)
      end
      it "sets @video variable" do
        expect(assigns(:video).description).to eq("A funny alien movie.")
      end
      it "sets the flash[:danger]" do
        expect(flash[:danger]).to be_present
      end
    end

  end
end
