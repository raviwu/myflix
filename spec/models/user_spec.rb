require 'spec_helper'

describe User do
  it { should have_many(:reviews).dependent(:destroy) }
  it { should have_many(:queue_items).order('position').dependent(:destroy) }
  it { should have_many(:followings).dependent(:destroy) }
  it { should have_many(:followeds).dependent(:destroy) }
  it { should have_many :followees }
  it { should have_many :followers }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }
  it { should validate_presence_of :fullname }
  it { should have_secure_password }
  it { should validate_length_of :password}

  describe '#queued?(video)' do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }

    it "returns true if the user already has the video in queue" do
      Fabricate(:queue_item, user: user, video: video, position: 1)
      expect(user.queued?(video)).to be_truthy
    end
    it "returns false if the user does not have the video in queue" do
      expect(user.queued?(video)).to be_falsey
    end
  end

  describe '#follow(user)' do
    let(:joe) { Fabricate(:user) }
    let(:alice) { Fabricate(:user) }
    let(:mark) { User.new }
    it "creates new followship if user exists" do
      joe.follow(alice)
      expect(alice.followers.first).to eq(joe)
    end
    it "does not create followship if user does not exist" do
      joe.follow(mark)
      expect(Followship.all.size).to eq(0)
    end
  end

  describe '#unfollow(user)' do
    let(:joe) { Fabricate(:user) }
    let(:alice) { Fabricate(:user) }
    let(:mark) { User.new }
    it "returns false if the followship does not exitst" do
      expect(joe.unfollow(mark)).to be_falsey
    end
    it "returns false if the followship does not exitst" do
      expect(joe.unfollow(alice)).to be_falsey
    end
    it "destroy the followship if user exists" do
      joe.follow(alice)
      joe.unfollow(alice)
      expect(joe.followees.size).to eq(0)
    end
  end

  describe "#followed?(user)" do
    let(:joe) { Fabricate(:user) }
    let(:alice) { Fabricate(:user) }
    it "returns true if the user followed user" do
      joe.follow(alice)
      expect(joe.followed?(alice)).to be_truthy
    end
    it "return false if the user does not follow user" do
      expect(joe.followed?(alice)).to be_falsey
    end
  end

  describe "#find_followship(user)" do
    let(:joe) { Fabricate(:user) }
    let(:alice) { Fabricate(:user) }
    it "returns followship of the assigned followee that user follow" do
      joe.follow(alice)
      expect(joe.find_followship(alice)).to eq(Followship.where(follower: joe, followee: alice).first)
    end
    it "returns false if the followship is not found" do
      expect(joe.find_followship(alice)).to be_falsey
    end
  end

end
