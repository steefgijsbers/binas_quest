require 'spec_helper'

describe Levelpack do
  
  let(:levelpack) { FactoryGirl.create(:levelpack) }
  
  subject { levelpack }
  
  it { should respond_to(:name) }
  it { should respond_to(:title) }
  it { should respond_to(:solution) }
  
  
  describe "when name is not present" do
    before { levelpack.name = " " }   
    it { should_not be_valid }
  end
  
  describe "when name format is invalid" do
    it "should be invalid" do
      wrong_names = %w[levelpack levelpack_ levelpack_a levelpacks_1 l_01]
      wrong_names.each do |wrong_name|
        levelpack.name = wrong_name
        expect(levelpack).not_to be_valid
      end
    end
  end
  
  describe "when name format is valid" do
    it "should be valid" do
      valid_names = %w[levelpack_00 levelpack_01 levelpack_99]
      valid_names.each do |valid_name|
        levelpack.name = valid_name
        expect(levelpack).to be_valid
      end
    end
  end
  
  describe "when name is already taken" do
    it "should not be valid" do
      levelpack_with_same_name = levelpack.dup
      levelpack_with_same_name.name.upcase!
      expect(levelpack_with_same_name).not_to be_valid
    end
  end
  
  
  describe "when title is not present" do
    before { levelpack.title = " " }    
    it { should_not be_valid }
  end
  
  describe "when title is too long" do
    before { levelpack.title = "a" * 51 }
    it { should_not be_valid }
  end
 
  
  describe "when solution is not present" do
    before { levelpack.solution = "" }
    it { should be_valid }
  end
  
  describe "when solution format is invalid" do
    it "should not be valid" do
      wrong_solutions = %w[He heheHe he1 1he]
      wrong_solutions.each do |wrong_solution|
        levelpack.solution = wrong_solution
        expect(levelpack).not_to be_valid
      end
    end
  end
end
