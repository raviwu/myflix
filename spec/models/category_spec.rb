require 'spec_helper'

describe Category do
  it { should have_many :videos }
  it { should validate_presence_of :title}

  let(:comedy) { Category.create(title: 'comedy') }
  let(:action) { Category.create(title: 'action') }

  let(:up) { Video.create(title: 'Up', description: 'description') }
  let(:se7en) { Video.create(title: 'Se7en', description: 'description', created_at: 1.day.ago) }

  describe "#recent_videos" do
    it "returns videos in created_at desc order" do
      up.categories << comedy
      se7en.categories << comedy
      expect(comedy.recent_videos).to eq([up, se7en])
    end

    it "returns empty array if the category has no video" do
      expect(comedy.recent_videos).to eq([])
    end

    it "returns array contains all video if the category has less than RECENT_VIDEO_QTY videos" do
      up.categories << comedy
      expect(comedy.recent_videos.count).to eq(1)
    end

    it "returns array contains only 6 videos if the category has more than RECENT_VIDEO_QTY video" do
      videos = []
      over_insert = 2
      (Category::RECENT_VIDEO_QTY + over_insert).times do |n|
        videos[n] = Fabricate(:video)
        videos[n].categories << comedy
      end
      videos.shift(over_insert)
      expect(comedy.recent_videos).to eq(videos.reverse)
    end

    it "returns the most recent RECENT_VIDEO_QTY videos" do
      videos = []
      Category::RECENT_VIDEO_QTY.times do |n|
        videos[n] = Fabricate(:video)
        videos[n].categories << comedy
      end
      se7en.categories << comedy
      expect(comedy.recent_videos).not_to include(se7en)
    end

    it "returns videos only belongs to the query category" do
      up.categories << comedy
      se7en.categories << action
      expect(comedy.recent_videos).to eq([up])
    end
  end
end
