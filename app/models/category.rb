class Category < ActiveRecord::Base
  has_many :video_classifications
  has_many :videos, -> { order('title') }, through: :video_classifications

  validates :title, presence: true

  def recent_videos
    self.videos.sort_by {|v| v.created_at}.reverse[0..5]
  end

end
