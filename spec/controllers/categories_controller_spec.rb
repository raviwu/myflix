require 'spec_helper'

describe CategoriesController do
  let(:user) { Fabricate(:user) }
  let(:category) { Fabricate(:category) }

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
    it "sets the @category" do
      session[:user_id] = user.id
      get :show, id: category.id
      assigns(:category).should eq(category)
    end
  end
end
