require 'spec_helper'

describe Category do
  it { should have_many :videos }
  it { should validate_presence_of :title}

  describe "#recent_videos" do
    it "returns videos in created_at desc order" do
      comedy = Category.create(title: 'comedy')
      up = Video.create(title: 'Up', description: 'description')
      up.categories << comedy
      se7en = Video.create(title: 'Se7en', description: 'description', created_at: 1.day.ago)
      se7en.categories << comedy
      expect(comedy.recent_videos).to eq([up, se7en])
    end

    it "returns empty array if the category has no video" do
      comedy = Category.create(title: 'comedy')
      expect(comedy.recent_videos).to eq([])
    end

    it "returns array contains all video if the category has less than RECENT_VIDEO_QTY videos" do
      comedy = Category.create(title: 'comedy')
      up = Video.create(title: 'Up', description: 'description')
      up.categories << comedy
      expect(comedy.recent_videos.count).to eq(1)
    end

    it "returns array contains only 6 videos if the category has more than RECENT_VIDEO_QTY video" do
      comedy = Category.create(title: 'comedy')
      videos = []
      over_insert = 2
      (Category::RECENT_VIDEO_QTY + over_insert).times {|n| videos[n] = Video.create(title: "video #{n}", description: 'description')}
      videos.each {|video| video.categories << comedy }
      videos.shift(over_insert)
      expect(comedy.recent_videos).to eq(videos.reverse)
    end

    it "returns the most recent RECENT_VIDEO_QTY videos" do
      comedy = Category.create(title: 'comedy')
      videos = []
      Category::RECENT_VIDEO_QTY.times {|n| videos[n] = Video.create(title: "video #{n}", description: 'description')}
      videos.each {|v| v.categories << comedy}
      last_night_show = Video.create(title: "last night show", description: "last night show", created_at: 1.day.ago)
      last_night_show.categories << comedy
      expect(comedy.recent_videos).not_to include(last_night_show)
    end

    it "returns videos only belongs to the query category" do
      comedy = Category.create(title: 'comedy')
      action = Category.create(title: 'action')
      south_park = Video.create(title: "South Part", description: 'funny movie')
      south_park.categories << comedy
      die_hard = Video.create(title: "Die Hard", description: 'action movie')
      die_hard.categories << action
      expect(comedy.recent_videos).to eq([south_park])
    end
  end
end
