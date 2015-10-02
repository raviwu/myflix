class Video < ActiveRecord::Base
  has_many :video_classifications
  has_many :categories, -> { order('title') }, through: :video_classifications

  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(query)
    return [] if query.blank?
    where("title LIKE ?", "%#{query}%").order(created_at: :desc)
  end
end
