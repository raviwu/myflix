require 'spec_helper'

describe VideosController do
  let(:video) { Fabricate(:video) }

  describe "GET index" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end

    it "sets the @categories variable with authenticated user" do
      set_current_user
      get :index
      2.times { Fabricate(:category) }
      expect(assigns(:categories)).to eq(Category.all)
    end
  end

  describe "GET show" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: Faker::Number.digit }
    end

    context "with authenticated user" do
      before do
        set_current_user
      end
      it "sets the @video variable" do
        get :show, id: video.id
        assigns(:video).should eq(video)
      end
      it "sets the @review variable" do
        get :show, id: video.id
        expect(assigns(:review)).to be_new_record
        expect(assigns(:review)).to be_instance_of(Review)
      end
    end
  end

  describe "GET search" do
    let(:random_query) { Faker::Lorem.word }

    it_behaves_like "require_sign_in" do
      let(:action) { get :search, query: random_query }
    end

    context "with authenticated user" do
      before do
        set_current_user
      end
      it "sets the @query variable" do
        get :search, query: random_query
        expect(assigns(:query)).to eq(random_query)
      end
      it "sets the @results variable" do
        up = Fabricate(:video, title: 'Up')
        get :search, query: 'up'
        expect(assigns(:results)).to eq([up])
      end
    end
  end

  describe "POST create_review" do
    let(:valid_review_params) { {body: "this is a review", rating: 4} }
    let(:invalid_review_params) { {body: ""} }

    it_behaves_like "require_sign_in" do
      let(:action) { post :create_review, id: 2 }
    end

    context "with authenticated user" do
      before do
        set_current_user
      end
      it "sets the @review variable with input" do
        post :create_review, id: video.id, review: valid_review_params
        expect(assigns(:review)).to be_present
      end
      it "saves video if the input is valid" do
        post :create_review, id: video.id, review: valid_review_params
        expect(Review.last.video).to eq(video)
      end
      it "sets the flash[:success]" do
        post :create_review, id: video.id, review: valid_review_params
        expect(flash[:success]).to be_present
      end
      it "redirects to video show page if the record is saved" do
        post :create_review, id: video.id, review: valid_review_params
        expect(response).to redirect_to(video_path(video))
      end
      it "does not create review if input params is invalid" do
        post :create_review, id: video.id, review: invalid_review_params
        expect(video.reviews.count).to eq(0)
      end
      it "renders the video show page if the input params is invalid" do
        post :create_review, id: video.id, review: invalid_review_params
        expect(response).to render_template(:show)
      end
      it "sets review.errors if input is invalid" do
        post :create_review, id: video.id, review: invalid_review_params
        expect(assigns(:review).errors.any?).to be_truthy
      end
    end
  end
end
