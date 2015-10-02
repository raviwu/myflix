require 'spec_helper'

describe Category do
  it { should have_many :videos }
  it { should validate_presence_of :title}

  describe "#recent_videos" do
    it "returns empty array if the category has no video" do
      comedy = Category.create(title: 'comedy')
      expect(comedy.recent_videos).to eq([])
    end

    it "returns array contains all video if the category has less than 6 videos" do
      comedy = Category.create(title: 'comedy')
      video = Video.create(title: 'video', description: 'description')
      video.categories << comedy
      expect(comedy.recent_videos).to eq([video])
    end

    it "returns array contains only 6 videos if the category has more than 6 video" do
      comedy = Category.create(title: 'comedy')
      videos = []
      8.times do |n|
        videos[n] = Video.create(title: "video #{n}", description: 'description')
      end
      videos.each {|video| video.categories << comedy }
      videos.shift(2)
      expect(comedy.recent_videos).to eq(videos.reverse)
    end

    it "returns videos in created_at desc order" do
      comedy = Category.create(title: 'comedy')
      video_1 = Video.create(title: 'video_1', description: 'description')
      video_1.categories << comedy
      video_2 = Video.create(title: 'video_2', description: 'description')
      video_2.categories << comedy
      expect(comedy.recent_videos).to eq([video_2, video_1])
    end
  end
end
