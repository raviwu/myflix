require 'spec_helper'

describe Admin::PaymentsController do
  describe "GET index" do
    it_behaves_like 'require_admin' do
      let(:action) { get :index }
    end

    it "shows the last 10 records of payment" do
      15.times { Fabricate(:payment) }
      set_current_admin
      get :index
      expect(assigns(:payments).size).to eq(10)
    end
  end
end
