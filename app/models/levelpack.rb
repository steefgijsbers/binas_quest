class Levelpack < ActiveRecord::Base
  before_save { self.name = name.downcase }
  
  VALID_NAME_REGEX =     /\A(levelpack)\_\d\d\Z/  # in de vorm levelpack_00
  VALID_SOLUTION_REGEX = /\A[a-z]*\Z/             # 0 of meer lowercase letters
  validates :name,  presence: true, format: { with: VALID_NAME_REGEX }, uniqueness: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :solution, format: { with: VALID_SOLUTION_REGEX }
  
end
