class Invitation < ActiveRecord::Base
  include Tokenable
  
  belongs_to :invitor, class_name: 'User', foreign_key: 'user_id', dependent: :destroy

  validates :recipient_fullname, presence: true
  validates :recipient_email, presence: true
  validates :message, presence: true

end
