class ULpRelationship < ActiveRecord::Base
  belongs_to :user
  belongs_to :levelpack
  
  validates :user_id,      presence: true
  validates :levelpack_id, presence: true
  
end
