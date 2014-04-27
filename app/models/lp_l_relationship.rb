class LpLRelationship < ActiveRecord::Base
  belongs_to :levelpack
  belongs_to :level
  
  validates :levelpack_id, presence: true
  validates :level_id,     presence: true
  
end
