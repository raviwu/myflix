require 'spec_helper'

describe QueueItem do
  it { should belong_to :user }
  it { should belong_to :video }

  describe "position datatype" do
    let(:queue_item) { Fabricate(:queue_item, position: 1) }

    it "is not to be string" do
      expect(queue_item.update(position: 'a')).to be_falsey
    end
    it "is greater than 0" do
      expect(queue_item.update(position: 0)).to be_falsey
    end
    it "is an integer" do
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
    let(:video) { Fabricate(:video) }
    let(:user) { Fabricate(:user) }
    let(:queue_item) { Fabricate(:queue_item, video: video, user: user) }
    it "returns the rating of the user that gave the video before in review" do
      review = Fabricate(:review, video: video, creator: user, rating: 5)
      expect(queue_item.rating).to eq(5)
    end
    it "returns nil when review is not present" do
      expect(queue_item.rating).to be_nil
    end
  end

  describe "#categories" do
    let(:video) { Fabricate(:video) }

    it "returns the array of category objects that the associated video belongs to" do
      comedy = Fabricate(:category)
      action = Fabricate(:category)
      video.categories << comedy
      video.categories << action
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.categories).to match_array([comedy, action])
    end

    it "returns emtpy array if the video not belongs to any category" do
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.categories).to eq([])
    end
  end

  describe "#rating=" do
    let(:video) { Fabricate(:video) }
    let(:user) { Fabricate(:user) }

    context "review exits" do
      let(:queue_item) { Fabricate(:queue_item, user: user, video: video) }
      before do
        Fabricate(:review, video: video, creator: user, rating: 5)
      end
      it "updates the related rating" do
        queue_item.rating=(1)
        expect(queue_item.reload.rating).to eq(1)
      end
      it "clears the rating if rating nil" do
        queue_item.rating=(nil)
        expect(queue_item.reload.rating).to eq(nil)
      end
    end

    it "create a review with the rating if the review does not exist" do
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating=(5)
      expect(queue_item.reload.rating).to eq(5)
    end
  end

end
