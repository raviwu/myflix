require 'spec_helper'

describe CategoriesController do
  describe "GET index" do
    it "redirects to sign_in_path when not logged in" do
      get :index
      response.should redirect_to(sign_in_path)
    end
    it "sets the @categories variable" do
      user = User.create(email: "user@example.com", fullname: "user", password: "password")
      session[:user_id] = user.id
      get :index
      assigns(:categories).should eq(Category.all)
    end
  end

  describe "GET show" do
    it "redirects to sign_in_path when not logged in" do
      get :show, id: 1
      response.should redirect_to(sign_in_path)
    end
    it "sets the @category" do
      user = User.create(email: "user@example.com", fullname: "user", password: "password")
      session[:user_id] = user.id
      comedy = Category.create(title: 'comedy')
      get :show, id: comedy.id
      assigns(:category).should eq(comedy)
    end
  end
end
