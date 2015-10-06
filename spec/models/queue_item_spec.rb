require 'spec_helper'

describe QueueItem do
  it { should belong_to :user }
  it { should belong_to :video }

  describe "position datatype" do
    it "is not to be string" do
      queue_item = Fabricate(:queue_item, position: 1)
      expect(queue_item.update(position: 'a')).to be_falsey
    end
    it "is greater than 0" do
      queue_item = Fabricate(:queue_item, position: 1)
      expect(queue_item.update(position: 0)).to be_falsey
    end
    it "is an integer" do
      queue_item = Fabricate(:queue_item, position: 1)
      expect(queue_item.update(position: 5.5)).to be_falsey
    end
  end

  describe "#video_title" do
    it "returns the video title of associated video" do
      video = Fabricate(:video, title: 'Up')
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq('Up')
    end
  end

  describe "#rating" do
    it "returns the rating of the user that gave the video before in review" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, video: video, creator: user, rating: 5)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq(5)
    end
    it "returns nil when review is not present" do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.rating).to be_nil
    end
  end

  describe "#categories" do
    it "returns the array of category objects that the associated video belongs to" do
      comedy = Fabricate(:category)
      action = Fabricate(:category)
      video = Fabricate(:video)
      video.categories << comedy
      video.categories << action
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.categories).to match_array([comedy, action])
    end

    it "returns emtpy array if the video not belongs to any category" do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.categories).to eq([])
    end
  end

end
