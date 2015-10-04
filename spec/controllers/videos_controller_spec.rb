require 'spec_helper'

describe VideosController do
  let(:user) { Fabricate(:user) }
  let(:video) { Fabricate(:video) }
  let(:random_query) { Faker::Lorem.word }
  let(:valid_review_params) { {body: "this is a review", rating: 4} }
  let(:invalid_review_params) { {body: ""} }

  describe "GET index" do
    it "redirects to sign_in_path when not logged in" do
      get :index
      response.should redirect_to(sign_in_path)
    end

    it "sets the @categories variable with authenticated user" do
      session[:user_id] = user.id
      get :index
      2.times { Fabricate(:category) }
        assigns(:categories).should eq(Category.all)
    end
  end

  describe "GET show" do
    it "redirects to sign_in_path when not logged in" do
      get :show, id: Faker::Number.digit
      response.should redirect_to(sign_in_path)
    end

    context "with authenticated user" do
      before do
        session[:user_id] = user.id
      end
      it "sets the @video variable" do
        get :show, id: video.id
        assigns(:video).should eq(video)
      end
      it "sets the @review variable" do
        get :show, id: video.id
        assigns(:review).should be_new_record
        assigns(:review).should be_instance_of(Review)
      end
    end
  end

  describe "GET search" do
    it "redirects to sign_in_path when not logged in" do
      get :search, query: random_query
      response.should redirect_to(sign_in_path)
    end

    context "with authenticated user" do
      before do
        session[:user_id] = user.id
      end
      it "sets the @query variable" do
        get :search, query: random_query
        assigns(:query).should eq(random_query)
      end
      it "sets the @results variable" do
        up = Fabricate(:video, title: 'Up')
        get :search, query: 'up'
        assigns(:results).should eq([up])
      end
    end
  end

  describe "POST create_review" do
    it "redirects to sign_in_path when not logged in" do
      post :create_review, id: video.id
      response.should redirect_to(sign_in_path)
    end

    context "with authenticated user" do
      before do
        session[:user_id] = user.id
      end
      it "sets the @review variable with input" do
        post :create_review, id: video.id, review: valid_review_params
        assigns(:review).should_not be_nil
      end
      it "saves video if the input is valid" do
        post :create_review, id: video.id, review: valid_review_params
        expect(Review.last.video).to eq(video)
      end
      it "sets the flash[:success]" do
        post :create_review, id: video.id, review: valid_review_params
        expect(flash[:success]).not_to be_nil
      end
      it "redirects to video show page if the record is saved" do
        post :create_review, id: video.id, review: valid_review_params
        response.should redirect_to(video_path(video))
      end
      it "does not create review if input params is invalid" do
        post :create_review, id: video.id, review: invalid_review_params
        expect(video.reviews.count).to eq(0)
      end
      it "renders the video show page if the input params is invalid" do
        post :create_review, id: video.id, review: invalid_review_params
        response.should render_template :show
      end
      it "sets review.errors if input is invalid" do
        post :create_review, id: video.id, review: invalid_review_params
        expect(assigns(:review).errors.any?).to be_truthy
      end
    end
  end
end
