class Category < ActiveRecord::Base
  has_many :video_classifications
  has_many :videos, -> { order('title') }, through: :video_classifications

  validates :title, presence: true

  def recent_videos
    Video.all.order(created_at: :desc).limit(6)
  end

end
