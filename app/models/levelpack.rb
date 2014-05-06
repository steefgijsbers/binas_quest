class Levelpack < ActiveRecord::Base
  has_many :u_lp_relationships, foreign_key: "levelpack_id", dependent: :destroy
  
  has_many :lp_l_relationships, foreign_key: "levelpack_id", dependent: :destroy
  has_many :levels, through: :lp_l_relationships
  
  VALID_NAME_REGEX =     /\A(levelpack)\_\d\d\Z/  # in de vorm levelpack_00
  VALID_SOLUTION_REGEX = /\A[a-z]*\Z/             # 0 of meer lowercase letters
  validates :name,  presence: true, format: { with: VALID_NAME_REGEX }, uniqueness: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :solution, format: { with: VALID_SOLUTION_REGEX }
  
  def corresponding_levels
    self.levels(true)
  end
  
  def add!(level)
    self.levels << level
    #self.lp_l_relationships.create!(level_id: level.id)
  end
  
  def update_solution
    solution = corresponding_levels.inject("") { |memo, lvl| memo + lvl.solution }
    self.update_attribute(:solution, solution)      
  end
  
  def remove!(level)
    self.lp_l_relationships.find_by(level_id: level.id).destroy
  end
  
  def containing?(level)
    self.lp_l_relationships.find_by(level_id: level.id)
  end
end
