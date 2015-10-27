class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_numericality_of :position, greater_than: 0, only_integer: true

  delegate :title, to: :video, prefix: :video

  def rating
    review ? review.rating : nil
  end

  def rating=(new_rating)
    if rating
      review.update_column(:rating, new_rating)
    elsif !rating && new_rating.blank?
    else
      review = Review.new(creator: user, video: video, rating: new_rating)
      review.save(validate: false)
    end
  end

  def category
    video.category
  end

  private

  def review
    @review ||= Review.where(creator: user, video: video).first
  end

end
