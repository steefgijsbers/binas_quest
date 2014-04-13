require 'spec_helper'

describe Level do
  
  before { @level = Level.new(name: 'test_level', img_src: 'test_level.jpg', solution: 'he') }
  
  subject { @level }
  
  it { should respond_to(:name) }
  it { should respond_to(:img_src) }
  it { should respond_to(:solution) }
  
  it { should be_valid }
  
  describe "when name is not present" do
    before { @level.name = " " }
    it { should_not be_valid }
  end
  
  describe "when img_src is not present" do
    before { @level.img_src = " " }
    it { should_not be_valid }
  end
  
  describe "when solution is not present" do
    before { @level.solution = " " }
    it { should_not be_valid }
  end
  
  describe "when name is too long" do
    before {  @level.name = "a" * 51}
    it { should_not be_valid }
  end
  
  describe "when img_src format is invalid" do
    it "should be invalid" do
      invalid_sources = %w[testimg.g .jpg /assets/images/d.g /assets/ima/g.bmp /images/f.jpg /assets/images/f.gif]
      invalid_sources.each do |src|
        @level.img_src = src
        expect(@level).not_to be_valid
      end
    end
  end
  
  describe "when img_src format is valid" do
    it "should be valid" do
      valid_sources = %w[level_1.jpg d.bmp 1.gif DDD.jpg]
      valid_sources.each do |src|
        @level.img_src = src
        expect(@level).to be_valid
      end
    end
  end
  
  describe "when name is already taken" do
    before do
      level_with_same_name = @level.dup
      level_with_same_name.name = @level.name.upcase
      level_with_same_name.save
    end
    
    it { should_not be_valid }
  end
  
  describe "name with mixed case" do
    let(:mixed_case_name) { "LevEL1" }

    it "should be saved as all lower-case" do
      @level.name = mixed_case_name
      @level.save
      expect(@level.reload.name).to eq mixed_case_name.downcase
    end
  end
  
  describe "when solution format is invalid" do
    it "should be invalid" do
      invalid_solutions = %w[Au aaa a1 a_ a]
      invalid_solutions.each do |solution|
        @level.solution = solution
        expect(@level).not_to be_valid
      end
    end
  end
  
  describe "when solution format is valid" do
    it "should be valid" do
      valid_solutions = %w[au w]
      valid_solutions.each do |solution|
        @level.solution = solution
        expect(@level).to be_valid
      end
    end
  end
  
  describe "return value of find by name" do
    before { @level.save }
    let(:found_level) { Level.find_by(name: @level.name) }
    
    it { should eq found_level }
  end
end
