require 'spec_helper'

describe User do
  it { should have_many :reviews }
  it { should have_many(:queue_items).order('position') }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }
  it { should validate_presence_of :fullname }
  it { should have_secure_password }
  it { should validate_length_of :password}

  describe '#queued?(video)' do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    it "returns true if the user already has the video in queue" do
      queue = QueueItem.create(user: user, video: video, position: 1)
      expect(user.queued?(video)).to be_truthy
    end
    it "returns false if the user does not have the video in queue" do
      expect(user.queued?(video)).to be_falsey
    end
  end
end
