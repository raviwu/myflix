require 'spec_helper'

describe CategoriesController do
  describe "GET index" do
    it "sets the @categories variable"
    it "redirects to log_in_path when not logged in"
  end

  describe "GET show" do
    it "sets the @category"
    it "redirects to log_in_path when not logged in"
  end
end
