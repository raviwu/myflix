require 'spec_helper'

describe Video do
  it "saves iteself" do
    video = Video.new(title: "New Video", description: "description of the new video", small_cover_url: "/url/s.jpg", large_cover_url:"/url/l.jpg")
    video.save
    expect(Video.last).to eq(video)
  end

  it "has many categories" do
    south_park = Video.create(title: "South Park", description: "funny movie")
    comedy = Category.create(title: 'comedy')
    animation = Category.create(title: 'animation')
    south_park.categories << Category.all
    expect(south_park.categories).to eq([animation, comedy])
  end

  it "has title" do
    south_park = Video.new(title: nil, description: "some description")
    expect(south_park.save).to eq(false)
  end

  it "has description" do
    monk = Video.new(title: "Monk", description: nil)
    expect(monk.save).to eq(false)
  end
end
