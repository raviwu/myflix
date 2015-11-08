require 'spec_helper'

describe Admin::PaymentsController do
  describe "GET index" do
    it_behaves_like 'require_admin' do
      let(:action) { get :index }
    end

    it "shows the last 10 records of payment" do
      alice = Fabricate(:user, fullname: 'Alice')
      10.times { Fabricate(:payment, user: alice) }
      joe = Fabricate(:user, fullname: 'Joe')
      10.times { Fabricate(:payment, user: joe) }
      set_current_admin
      get :index
      expect(assigns(:payments).size).to eq(10)
      expect(assigns(:payments).first.user.fullname).to eq('Joe')
      expect(assigns(:payments).last.user.fullname).to eq('Joe')
    end
  end
end
