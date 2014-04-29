class Levelpack < ActiveRecord::Base
  has_many :lp_l_relationships, foreign_key: "levelpack_id", dependent: :destroy
  has_many :corresponding_levels, through: :lp_l_relationships, source: :level
  
  before_save { self.name = name.downcase }
  
  VALID_NAME_REGEX =     /\A(levelpack)\_\d\d\Z/  # in de vorm levelpack_00
  VALID_SOLUTION_REGEX = /\A[a-z]*\Z/             # 0 of meer lowercase letters
  validates :name,  presence: true, format: { with: VALID_NAME_REGEX }, uniqueness: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :solution, format: { with: VALID_SOLUTION_REGEX }
  
  
  def add!(level)
    self.lp_l_relationships.create!(level_id: level.id)
    solution = self.solution
    solution += level.solution
    self.update_attribute(:solution, solution)
  end
  
  def remove!(level)
    self.lp_l_relationships.find_by(level_id: level.id).destroy
  end
  
  def containing?(level)
    self.lp_l_relationships.find_by(level_id: level.id)
  end
end
