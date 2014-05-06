require 'spec_helper'

describe Levelpack do
  
  let(:levelpack) { FactoryGirl.create(:levelpack) }
  
  subject { levelpack }
  
  it { should respond_to :name }
  it { should respond_to :title }
  it { should respond_to :solution }
  it { should respond_to :u_lp_relationships }
  it { should respond_to :corresponding_levels }
  it { should respond_to :lp_l_relationships }
  it { should respond_to :containing? }
  it { should respond_to :add! }
  it { should respond_to :remove! }
  it { should respond_to :update_solution }
  
  it { should be_valid }
  
  #name attribute#
  
  describe "when name is not present" do
    before { levelpack.name = " " }
    it { should_not be_valid }
  end
  
  describe "when name does not have correct format" do
    it "should not be valid" do
      invalid_names = %w[Levelpack_01 levelpack_1 levelpack_001 levelp_1 alevelpack_01 levelpack_01a]
      invalid_names.each do |invalid_name|
        levelpack.name = invalid_name
        expect(levelpack).not_to be_valid
      end
    end
  end
  
  describe "when name has correct format" do
    it "should be valid" do
      valid_names = %w[levelpack_01 levelpack_99 levelpack_00]
      valid_names.each do |valid_name|
        levelpack.name = valid_name
        expect(levelpack).to be_valid
      end
    end
  end
  
  describe "when name is already taken" do
    it "should not be valid" do
      levelpack1 = FactoryGirl.create(:levelpack, name: "levelpack_99")
      levelpack2 = Levelpack.new(name: "levelpack_99", title: "example title")
      expect(levelpack2).not_to be_valid
    end
  end
  
  #title attribute#
  
  describe "when title is not present" do
    before { levelpack.title = " " }
    it { should_not be_valid }
  end
  
  describe "when title is too long" do
    before { levelpack.title = "a" * 51 }
    it { should_not be_valid }
  end
  
  #solution attribute#
  
  describe "when solution is nil" do
    before { levelpack.solution = nil }
    it { should be_valid }
  end
  
  #levelpack - level relationships
  
  let(:level_1) { FactoryGirl.create(:level, name: "level 1", solution: "he") }
  let(:level_2) { FactoryGirl.create(:level, name: "level 2", solution: "na") }
  
  describe "adding levels to levelpack" do
    before do
      levelpack.add! level_1
      levelpack.add! level_2
      levelpack.update_solution      
    end
    it { should be_containing level_1 }
    it { should be_containing level_2 }
    its(:corresponding_levels) { should include level_1 }
    its(:corresponding_levels) { should include level_2 }
    its(:solution) { should eq level_1.solution + level_2.solution }
  end 
end
