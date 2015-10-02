class Video < ActiveRecord::Base
  has_many :video_classifications
  has_many :categories, -> { order('title') }, through: :video_classifications

  validates :title, presence: true
  validates :description, presence: true
end
