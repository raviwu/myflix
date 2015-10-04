class Review < ActiveRecord::Base
  RATINGS = {'1 Star' => 1, '2 Stars' => 2, '3 Stars' => 3, '4 Stars' => 4, '5 Stars' => 5}

  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  belongs_to :video

  validates :body, presence: true
  validates_inclusion_of :rating, in: RATINGS.values
end
