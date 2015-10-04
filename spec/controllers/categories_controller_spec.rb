require 'spec_helper'

describe CategoriesController do
  let(:user) { Fabricate(:user) }
  let(:category) { Fabricate(:category) }

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
