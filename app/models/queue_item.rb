class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_numericality_of :position, greater_than: 0, only_integer: true

  delegate :title, to: :video, prefix: :video

  def rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review ? review.rating : nil
  end

  def categories
    video.categories
  end

end
