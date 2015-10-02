class Video < ActiveRecord::Base
  has_many :video_classifications
  has_many :categories, through: :video_classifications
end
