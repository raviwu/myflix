require 'spec_helper'

describe Category do
  it "save itself" do
    category = Category.new(title: 'animation')
    category.save
    expect(Category.last).to eq(category)
  end

  it "has many videos" do
    category = Category.create(title: 'fantacy')
    south_park = Video.create(title: 'South Park', description: 'funny movie')
    back_to_future = Video.create(title: 'Back to Future', description: 'time travel movie must see')
    videos = Video.all
    category.videos << videos
    expect(category.videos).to eq([back_to_future, south_park])
  end

  it { should validate_presence_of :title}
end
