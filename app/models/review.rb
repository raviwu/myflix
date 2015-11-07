class Review < ActiveRecord::Base
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id', dependent: :destroy
  belongs_to :video, dependent: :destroy, touch: true

  validates :body, presence: true
  validates :rating, presence: true
  validates_inclusion_of :rating, in: [1, 2, 3, 4, 5]
end
