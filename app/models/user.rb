class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, -> { order('position') }
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

end
