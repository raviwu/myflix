class Category < ActiveRecord::Base
  has_many :video_classifications
  has_many :videos, through: :video_classifications

end
