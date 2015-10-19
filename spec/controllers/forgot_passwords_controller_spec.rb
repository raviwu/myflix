require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST #create" do
    context 'with blank input' do
      before do
        post :create, email: ''
      end
      it 'redirects to forgot password' do
        expect(response).to redirect_to(forgot_password_path)
      end
      it 'sets flash[:danger]' do
        expect(flash[:danger]).to be_present
      end
    end

    context 'with invalid email' do
      before do
        post :create, email: 'random@example.com'
      end
      it 'redirects to forgot password' do
        expect(response).to redirect_to(forgot_password_path)
      end
      it 'sets flash[:danger]' do
        expect(flash[:danger]).to be_present
      end
    end

    context 'with correct email' do
      before do
        Fabricate(:user, fullname: 'Joe Doe', email: 'joe@example.com')
        post :create, email: 'joe@example.com'
      end
      after { ActionMailer::Base.deliveries.clear }
      it 'sends out email to user email' do
        expect(ActionMailer::Base.deliveries.size).to eq(1)
      end
      it 'sends email to correct recipient' do
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end
      it 'sends email with correct content' do
        expect(ActionMailer::Base.deliveries.last.body).to include('Reset My Password')
      end
      it 'redirects to confirm_password_reset_path' do
        expect(response).to redirect_to(confirm_password_reset_path)
      end
    end
  end
end
