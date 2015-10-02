require 'spec_helper'

describe Category do
  it "save itself" do
    category = Category.new(title: 'animation')
    category.save
    expect(Category.last).to eq(category)
  end

  it "has many videos" do
    category = Category.create(title: 'animation')
    5.times do
      Video.create(title: 'sample video', description: 'sample description')
    end
    videos = Video.all
    category.videos << videos
    expect(category.videos.size).to eq(Video.all.size)
  end
end
