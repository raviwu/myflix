require 'spec_helper'

describe Invitation do
  it { should belong_to(:invitor).dependent(:destroy) }
  it { should validate_presence_of(:recipient_fullname) }
  it { should validate_presence_of(:recipient_email) }
  it { should validate_presence_of(:message) }

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:invitation) }
  end
end
