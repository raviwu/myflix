require 'spec_helper'

describe Invitation do
  it { should belong_to(:invitor).dependent(:destroy) }
  it { should validate_presence_of(:recipient_fullname) }
  it { should validate_presence_of(:recipient_email) }
  it { should validate_presence_of(:message) }

  it "generate a random token when the invitation is created" do
    invite = Fabricate(:invitation)
    expect(invite.token).to be_present
  end
end
