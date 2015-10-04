class User < ActiveRecord::Base
  has_many :reviews
  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/ }
  validates :fullname, presence: true
  validates :password, length: { minimum: 6 }

end
