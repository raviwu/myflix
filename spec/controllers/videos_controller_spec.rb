require 'spec_helper'

describe VideosController do
  let(:user) { Fabricate(:user) }
  let(:video) { Fabricate(:video) }
  let(:random_query) { Faker::Lorem.word }

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

    it "sets the @video variable with authenticated user" do
      session[:user_id] = user.id
      get :show, id: video.id
      assigns(:video).should eq(video)
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
end
