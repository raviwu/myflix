require 'spec_helper'

describe CategoriesController do

  describe "GET show" do

    it_behaves_like "require_sign_in" do
      let(:action) {get :show, id: Faker::Number.digit}
    end

    it "sets the @category with authenticated user" do
      set_current_user
      category = Fabricate(:category)
      get :show, id: category.id
      expect(assigns(:category)).to eq(category)
    end
  end
end
