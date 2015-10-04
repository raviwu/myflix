class Video < ActiveRecord::Base
  has_many :video_classifications
  has_many :categories, -> { order('title') }, through: :video_classifications
  has_many :reviews

  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(query)
    return [] if query.blank?
    where("lower(title) LIKE ?", "%#{query}%").order(created_at: :desc)
  end

  def avg_rating
    ratings = []
    reviews.each { |review| ratings << review.rating }
    ratings.empty? ? 0 : (ratings.sum.to_f / ratings.size).round(1)
  end
end
