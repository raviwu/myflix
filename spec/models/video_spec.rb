require 'spec_helper'

describe Video do
  it { should have_many :categories }
  it { should validate_presence_of :title}
  it { should validate_presence_of :description}

  describe "#search_by_title" do
    it "returns empty array if the search query is not found" do
      video_1 = Video.create(title: 'video 1', description: 'video description')
      video_2 = Video.create(title: 'video 2', description: 'video description')
      expect(Video.search_by_title('nothistitle')).to eq([])
    end

    it "returns empty array if the search query is blank string" do
      video_1 = Video.create(title: 'video 1', description: 'video description')
      video_2 = Video.create(title: 'video 2', description: 'video description')
      expect(Video.search_by_title("")).to eq([])
    end

    it "returns emtpy array if the search query is all white space" do
      video_1 = Video.create(title: 'video 1', description: 'video description')
      video_2 = Video.create(title: 'video 2', description: 'video description')
      expect(Video.search_by_title("       ")).to eq([])
    end

    it "returns array of exactly matches" do
      title = 'video title'
      video = Video.create(title: title, description: 'video description')
      expect(Video.search_by_title(title)).to eq([video])
    end

    it "returns array of partial matches" do
      video_1 = Video.create(title: 'video 1', description: 'video description')
      video_2 = Video.create(title: 'video 2', description: 'video description')
      expect(Video.search_by_title('vid')).to eq([video_2, video_1])
    end

    it "returns array of all matches ordered by created_at" do
      video_first = Video.create(title: 'video first', description: 'video description')
      video_second = Video.create(title: 'video second', description: 'video description')
      expect(Video.search_by_title('video')).to eq([video_second, video_first])
    end
  end
end
