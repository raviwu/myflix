class Category < ActiveRecord::Base
  has_many :videos, -> { order('created_at DESC') }

  validates :title, presence: true

  RECENT_VIDEO_QTY = 6

  def recent_videos
    videos.limit(RECENT_VIDEO_QTY)
  end

end
