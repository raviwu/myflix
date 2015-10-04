require 'spec_helper'

describe Video do
  it { should have_many :categories }
  it { should validate_presence_of :title}
  it { should validate_presence_of :description}

  let!(:video_1) { Fabricate(:video, title: 'video_1') }
  let!(:video_2) { Fabricate(:video, title: 'video_2') }

  describe "#search_by_title" do
    it "returns empty array if the search query is not found" do
      expect(Video.search_by_title('nothistitle')).to eq([])
    end

    it "returns empty array if the search query is blank string" do
      expect(Video.search_by_title("")).to eq([])
    end

    it "returns emtpy array if the search query is all white space" do
      expect(Video.search_by_title("       ")).to eq([])
    end

    it "returns array of partial matches" do
      expect(Video.search_by_title('vid')).to eq([video_2, video_1])
    end

    it "returns array of all matches ordered by created_at" do
      expect(Video.search_by_title('video')).to eq([video_2, video_1])
    end
  end
end
