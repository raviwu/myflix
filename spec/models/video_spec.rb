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

  describe ".search", :elasticsearch do
    let(:refresh_index) do
      Video.import
      Video.__elasticsearch__.refresh_index!
    end

    context "with title" do
      it "returns no results when there's no match" do
        Fabricate(:video, title: "Futurama")
        refresh_index

        expect(Video.search("whatever").records.to_a).to eq []
      end

      it "returns an empty array when there's no search term" do
        futurama = Fabricate(:video)
        south_park = Fabricate(:video)
        refresh_index

        expect(Video.search("").records.to_a).to eq []
      end

      it "returns an array of 1 video for title case insensitve match" do
        futurama = Fabricate(:video, title: "Futurama")
        south_park = Fabricate(:video, title: "South Park")
        refresh_index

        expect(Video.search("futurama").records.to_a).to eq [futurama]
      end

      it "returns an array of many videos for title match" do
        star_trek = Fabricate(:video, title: "Star Trek")
        star_wars = Fabricate(:video, title: "Star Wars")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_trek, star_wars]
      end
    end

    context "with title and description" do
      it "returns an array of many videos based for title and description match" do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "sun is a star")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_wars, about_sun]
      end
    end

    context "multiple words must match" do
      it "returns an array of videos where 2 words match title" do
        star_wars_1 = Fabricate(:video, title: "Star Wars: Episode 1")
        star_wars_2 = Fabricate(:video, title: "Star Wars: Episode 2")
        bride_wars = Fabricate(:video, title: "Bride Wars")
        star_trek = Fabricate(:video, title: "Star Trek")
        refresh_index

        expect(Video.search("Star Wars").records.to_a).to match_array [star_wars_1, star_wars_2]
      end
    end
  end

end
