require 'spec_helper'

describe Category do
  it { should have_many :videos }
  it { should validate_presence_of :title}

  let(:comedy) { Fabricate(:category) }
  let(:action) { Fabricate(:category) }

  let(:up) { Fabricate(:video, title: 'Up', category: nil) }
  let(:se7en) { Fabricate(:video, title: 'Se7en', created_at: 1.day.ago, category: nil) }

  describe "#recent_videos" do
    it "returns videos in created_at desc order" do
      comedy.videos << up
      comedy.videos << se7en
      expect(comedy.recent_videos).to eq([up, se7en])
    end

    it "returns empty array if the category has no video" do
      expect(comedy.recent_videos).to eq([])
    end

    it "returns array contains all video if the category has less than RECENT_VIDEO_QTY videos" do
      comedy.videos << up
      expect(comedy.recent_videos.count).to eq(1)
    end

    it "returns array contains only 6 videos if the category has more than RECENT_VIDEO_QTY video" do
      videos = []
      over_insert = 2
      (Category::RECENT_VIDEO_QTY + over_insert).times do |n|
        videos[n] = Fabricate(:video, category: comedy)
      end
      videos.shift(over_insert)
      expect(comedy.recent_videos).to eq(videos.reverse)
    end

    it "returns the most recent RECENT_VIDEO_QTY videos" do
      videos = []
      Category::RECENT_VIDEO_QTY.times do |n|
        videos[n] = Fabricate(:video, category: comedy)
      end
      se7en.category = comedy
      expect(comedy.recent_videos).not_to include(se7en)
    end

    it "returns videos only belongs to the query category" do
      comedy.videos << up
      action.videos << se7en
      expect(comedy.recent_videos).to eq([up])
    end
  end
end
