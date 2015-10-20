require 'spec_helper'

describe InviteUsersController do
  describe "POST #create" do
    let(:fullname) { 'Alice Chou'}
    let(:email) { 'alice@example.com' }
    let(:message) { "Hi, Alice. Please join MyFLix with me!" }

    it_behaves_like 'require_sign_in' do
      let(:action) { post :create }
    end

    context 'with valid input' do
      before do
        ActionMailer::Base.deliveries.clear
        set_current_user
        post :create, fullname: fullname, email: email, message: message
      end
      it 'redirects to home_path' do
        expect(response).to redirect_to(home_path)
      end
      it 'sends out email to guest email' do
        expect(ActionMailer::Base.deliveries.size).to eq(1)
      end
      it 'sends email to correct recipient' do
        expect(ActionMailer::Base.deliveries.last.to).to eq([email])
      end
      it 'sends email with correct content' do
        expect(ActionMailer::Base.deliveries.last.body).to include(message)
      end
      it 'sets flash[:success]' do
        expect(flash[:success]).to be_present
      end
    end
    context 'with invalid input' do
      before do
        set_current_user
        post :create, fullname: '', email: '', message: message
      end
      it 'sets flash[:danger]' do
        expect(flash[:danger]).to be_present
      end
      it 'render new' do
        expect(response).to render_template(:new)
      end
    end

  end
end
