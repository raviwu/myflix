require 'spec_helper'

describe Video do
  it { should belong_to :category }
  it { should have_many :queue_items }
  it { should have_many(:reviews).order('created_at DESC') }
  it { should validate_presence_of :title}
  it { should validate_presence_of :description}

  describe "#search_by_title" do
    let!(:video_1) { Fabricate(:video, title: 'video_1') }
    let!(:video_2) { Fabricate(:video, title: 'video_2') }

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
    let(:video) { Fabricate(:video) }

    it "returns 0 if there's no review" do
      expect(video.avg_rating).to eq(0)
    end
    it "returns avg_rating of all review ratings" do
      Fabricate(:review, video: video, rating: 2)
      Fabricate(:review, video: video, rating: 3)
      expect(video.avg_rating).to eq(2.5)
    end
    it "calculates the avg_rating even if reviews contain nil rating" do
      Fabricate(:review, video: video, rating: 5)
      review = Fabricate(:review, video: video)
      review.update_column(:rating, nil)
      expect(video.avg_rating).to eq(5)
    end
  end

end
