class User < ActiveRecord::Base
  validates :naam,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  VALID_KLAS_REGEX = /[1-6][mMhHvVaAgG][a-zA-Z]/
  validates :klas, presence: true, format: { with: VALID_KLAS_REGEX }
  
  before_save { self.email = email.downcase }
  
  has_secure_password
end
