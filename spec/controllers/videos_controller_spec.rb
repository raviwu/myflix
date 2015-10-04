require 'spec_helper'

describe VideosController do
  let(:user) { Fabricate(:user) }
  let(:video) { Fabricate(:video) } # title formatted as "Video Random Title"
  let(:random_query) { Faker::Lorem.word }

  describe "GET index" do
    it "redirects to sign_in_path when not logged in" do
      get :index
      response.should redirect_to(sign_in_path)
    end
    it "sets the @categories variable" do
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
    it "sets the @video variable" do
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
    it "sets the @query variable" do
      session[:user_id] = user.id
      get :search, query: random_query
      assigns(:query).should eq(random_query)
    end
    it "sets the @results variable as [] when no match" do
      session[:user_id] = user.id
      get :search, query: random_query
      assigns(:results).should eq([])
    end
    it "sets the @results variable" do
      session[:user_id] = user.id
      5.times { Fabricate(:video) }
      get :search, query: 'video'
      assigns(:results).should eq(Video.all.reverse)
    end
  end
end
