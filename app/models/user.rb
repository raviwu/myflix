class User < ActiveRecord::Base
  include Tokenable

  has_many :reviews, dependent: :destroy
  has_many :queue_items, -> { order('position') }, dependent: :destroy

  has_many :invitations, dependent: :destroy

  has_many :followings, class_name: 'Followship', foreign_key: 'follower_id', dependent: :destroy
  has_many :followeds, class_name: 'Followship', foreign_key: 'followee_id', dependent: :destroy

  has_many :followees, through: :followings, source: :followee
  has_many :followers, through: :followeds, source: :follower

  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/ }
  validates :fullname, presence: true
  validates :password, length: { minimum: 6 }

  def queued?(video)
    !QueueItem.where(user: self, video: video).empty?
  end

  def normalize_queue_items_position
    self.queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end

  def follow(user)
    Followship.create(follower: self, followee: user) if user
  end

  def unfollow(user)
    Followship.where(follower: self, followee: user).destroy_all if followed?(user)
  end

  def followed?(user)
    followees.include?(user)
  end

  def find_followship(user)
    if followed?(user)
      Followship.where(follower: self, followee: user).first
    else
      false
    end
  end

  def can_follow?(another_user)
    !(self == another_user || followed?(another_user))
  end

  def deactivate!
    update_column(:active, false)
  end

end
