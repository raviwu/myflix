class Video < ActiveRecord::Base
  belongs_to :category, -> { order('title') }
  has_many :reviews, -> { order('created_at DESC') }
  has_many :queue_items

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(query)
    return [] if query.blank?
    where("lower(title) LIKE ?", "%#{query}%").order(created_at: :desc)
  end

  def avg_rating
    ratings = []
    reviews.each { |review| ratings << review.rating }
    ratings.empty? ? 0 : (ratings.compact.sum.to_f / ratings.compact.size).round(1)
  end
end
