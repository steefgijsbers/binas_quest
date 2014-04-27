class Level < ActiveRecord::Base
  has_many :lp_l_relationships, foreign_key: "level_id", dependent: :destroy
  
  
  before_save { self.name = name.downcase }
  
  validates :name,      presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  
  VALID_IMGSRC_REGEX = /\A[a-zA-Z\d\-\_]+\.(jpg|jpeg|bmp|png|gif)\Z/
  validates :img_src,   presence: true, format: { with: VALID_IMGSRC_REGEX }
  
  VALID_SOLUTION_REGEX = /\A(h|he|
                             li|be|b|c|n|o|f|ne|
                             na|mg|al|si|p|s|cl|ar|
                             k|ca|sc|ti|v|cr|mn|fe|co|ni|cu|zn|ga|ge|as|se|br|kr|
                             rb|sr|y|zr|nb|mo|tc|ru|rh|pd|ag|cd|in|sn|sb|te|i|xe|
                             cs|ba|la|hf|ta|w|re|os|ir|pt|au|hg|tl|pb|bi|po|at|rn|
                             fr|ra|ac|rf|db|sg|bh|hs|mt|ds|rg|cn|fl|lv|
                             ce|pr|nd|pm|sm|eu|gd|tb|dy|ho|er|tm|yb|lu|
                             th|pa|u|np|pu|am|cm|bk|cf|es|fm|md|no|lr)\Z/
  validates :solution,  presence: true, format: { with: VALID_SOLUTION_REGEX }
  

end
