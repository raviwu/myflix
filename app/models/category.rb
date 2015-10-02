class Category < ActiveRecord::Base
  has_many :video_classifications
  has_many :videos, -> { order('title') }, through: :video_classifications

  validates :title, presence: true

  RECENT_VIDEO_QTY = 6

  def recent_videos
    self.videos.sort_by {|v| v.created_at}.reverse.take(RECENT_VIDEO_QTY)
  end

end
