require 'spec_helper'

describe InvitationsController do
  describe "GET #new" do
    it_behaves_like 'require_sign_in' do
      let(:action) { get :new }
    end
    it 'sets invitation variable' do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of(Invitation)
    end
  end
  describe "POST #create" do
    it_behaves_like 'require_sign_in' do
      let(:action) { post :create }
    end

    let(:valid_invitation_params) { {
      recipient_email: 'alice@example.com',
      recipient_fullname: 'Alice Chou',
      message: 'Join me here!' }}
    let(:invalid_invitation_params) { {
      message: 'Join me here!' }}

    context "with valid user input" do
      before do
        set_current_user
        clear_emailer_deliveries
        post :create, invitation: valid_invitation_params
      end
      it "sets the @invitation variable" do
        expect(assigns(:invitation)).to be_instance_of(Invitation)
      end
      it "saves the @invitation" do
        invitation = Invitation.find_by(recipient_email: 'alice@example.com')
        expect(Invitation.last).to eq(invitation)
      end
      it "sets the invitor as current_user" do
        invitation = Invitation.find_by(recipient_email: 'alice@example.com')
        expect(invitation.invitor).to eq(current_user)
      end
      it "sets the flash notice" do
        expect(flash[:success]).to be_present
      end
      it "redirects to home_path if the record is saved" do
        expect(response).to redirect_to(home_path)
      end
      it "sends out the email" do
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end
      it "sends to correct recipient" do
        mail = ActionMailer::Base.deliveries.last
        expect(mail.to).to eq(['alice@example.com'])
      end
      it "contains correct content" do
        mail = ActionMailer::Base.deliveries.last
        expect(mail.body).to include('Join me here!')
      end
    end

    context "with invalid input" do
      before do
        set_current_user
        clear_emailer_deliveries
        post :create, invitation: invalid_invitation_params
      end
      it "renders the new template" do
        expect(response).to render_template(:new)
      end
      it "does not send out email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

  end
end
