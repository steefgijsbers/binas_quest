class User < ActiveRecord::Base
  has_many :u_lp_relationships, foreign_key: "user_id", dependent: :destroy
  has_many :unlocked_levelpacks, through: :u_lp_relationships, source: :levelpack
  
  validates :naam,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  VALID_KLAS_REGEX = /[1-6][mMhHvVaAgG][a-zA-Z]/
  validates :klas, presence: true, format: { with: VALID_KLAS_REGEX }
  
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  
  has_secure_password
  
  def unlock!(levelpack)
    self.u_lp_relationships.create!(levelpack_id: levelpack.id)
  end
  
  def containing?(levelpack)
    self.u_lp_relationships.find_by(levelpack_id: levelpack.id)
  end
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end
    
  def User.hash(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  private    
  
    def create_remember_token
      self.remember_token = User.hash(User.new_remember_token)
    end
end
