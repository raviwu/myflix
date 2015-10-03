require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "redirects to sign_in_path when not logged in" do
      get :show, id: 1
      response.should redirect_to(sign_in_path)
    end
    it "sets the @video variable" do
      user = User.create(email: "user@example.com", fullname: "user", password: "password")
      session[:user_id] = user.id
      video = Video.create(title: 'video', description: 'description')
      get :show, id: video.id
      assigns(:video).should eq(video)
    end
  end

  describe "GET search" do
    it "redirects to sign_in_path when not logged in" do
      get :search, query: 'test'
      response.should redirect_to(sign_in_path)
    end
    it "sets the @query variable" do
      user = User.create(email: "user@example.com", fullname: "user", password: "password")
      session[:user_id] = user.id
      query = 'query string'
      get :search, query: query
      assigns(:query).should eq(query)
    end
    it "sets the @results variable as [] when no match" do
      user = User.create(email: "user@example.com", fullname: "user", password: "password")
      session[:user_id] = user.id
      query = 'query string'
      get :search, query: query
      assigns(:results).should eq([])
    end
    it "sets the @results variable" do
      user = User.create(email: "user@example.com", fullname: "user", password: "password")
      session[:user_id] = user.id
      5.times { Video.create(title: 'video', description: 'description') }
      query = 'video'
      get :search, query: query
      assigns(:results).should eq(Video.all.reverse)
    end
  end
end
