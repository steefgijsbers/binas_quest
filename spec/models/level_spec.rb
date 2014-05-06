require 'spec_helper'

describe Level do

  let(:level) { FactoryGirl.create(:level) }

  subject { level }
  
  it { should respond_to :name }
  it { should respond_to :img_src }
  it { should respond_to :thumb_src }
  it { should respond_to :solution }
  it { should respond_to :lp_l_relationships }

  it { should be_valid }
  
  #name attribute#
  
  describe "when name is not present" do
    before { level.name = " " }
    it { should_not be_valid }
  end
  
  describe "when name is too long" do
    before { level.name = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when name is already taken" do
    it "should not be valid" do
      level_with_same_name = level.dup
      level_with_same_name.name = level.name.upcase
      expect(level_with_same_name).not_to be_valid      
    end
  end
  
  describe "when level has mixed_case name" do
    let(:mixed_case_name) { "LeVEl 23" }
    it "should be saved all lowercase" do
      level_mixed_name = FactoryGirl.create(:level, name: mixed_case_name)
      expect(mixed_case_name.downcase).to eq level_mixed_name.reload.name
    end
  end
  
  #img_src attribute#
  
  describe "when img_src is not present" do
    before { level.img_src = " " }
    it { should_not be_valid }
  end
  
  describe "when img_src does not have correct format" do
    it "should be invalid" do
      wrong_img_srcs = %w[testimg.g .jpg /assets/images/d.g /assets/ima/g.bmp /images/f.jpg /assets/images/f.gif]
      wrong_img_srcs.each do |wrong_img_src|
        level.img_src = wrong_img_src
        expect(level).not_to be_valid
      end
    end
  end
  
  describe "when img_src has correct format" do
    it "should be valid" do
      valid_img_srcs = %w[level_1.jpg d.bmp 1.gif DDD.jpg]
      valid_img_srcs.each do |valid_img_src|
        level.img_src = valid_img_src
        expect(level).to be_valid
      end
    end
  end
  
  #thumb_src attribute#
  
  describe "when new level is created" do
    let(:new_level) { FactoryGirl.create(:level, name: "level 9999", img_src: "example.bmp") }
    it "should generate the correct thumb_src attribute" do
      new_level.generate_thumb_src
      expect(new_level.thumb_src).to eq "example_thumb.bmp"
    end
  end
  
  #solution attribute#
  
  describe "when solution is not present" do
    before { level.solution = " " }
    it { should_not be_valid }
  end
  
  describe "when solution does not have correct format" do
    it "should not be valid" do
      invalid_solutions = %w[Au aaa a1 a_ a]
      invalid_solutions.each do |invalid_solution|
        level.solution = invalid_solution
        expect(level).not_to be_valid
      end
    end
  end
  
  describe "when solution has correct format" do
    it "should be valid" do
      valid_solutions = %w[au w]
      valid_solutions.each do |valid_solution|
        level.solution = valid_solution
        expect(level).to be_valid
      end
    end
  end
  
  #level - levelpack relationships
    # not needed until one would like to call things as 'level.corresponding_levelpacks'
  

end