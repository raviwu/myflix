require 'spec_helper'

describe Video do
  it "saves iteself" do
    video = Video.new(title: "New Video", description: "description of the new video", small_cover_url: "/url/s.jpg", large_cover_url:"/url/l.jpg")
    video.save
    expect(Video.last).to eq(video)
  end
end
