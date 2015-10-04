require 'spec_helper'

describe Video do
  it { should have_many :categories }
  it { should have_many(:reviews).order('created_at DESC') }
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

  describe '#avg_rating' do
    it "returns 0 if there's no review" do
      expect(video_1.avg_rating).to eq(0)
    end
    it "returns avg_rating of all review ratings" do
      review_1 = Fabricate(:review, video: video_1)
      review_2 = Fabricate(:review, video: video_1)
      avg = (review_1.rating + review_2.rating).to_f / 2
      expect(video_1.avg_rating).to eq(avg)
    end
  end
end
