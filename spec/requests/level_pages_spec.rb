require 'spec_helper'

describe "Level Pages" do
  
  subject { page }
  
  describe "Upload page" do
    before { visit upload_path }
    
    it { should have_content('Upload Levels') }
    it { should have_title(full_title('Upload Levels')) } 
  end
  
  describe "Upload Level" do
    before { visit upload_path }
    
    let(:submit) { "Upload level" }
    
    describe "with invalid information" do
      it "should not create a new level" do
        expect { click_button submit }.not_to change(Level, :count) 
      end
    end
    
    describe "with valid information" do
      before do
        fill_in "name",       with: "Examplelevel"
        fill_in "img_src",    with: "example.jpg"
        fill_in "solution",   with: "he"
      end
      
      it "should create a new level" do
        expect { click_button submit }.to change(Level, :count).by(1)
      end
    end
  end
  
  describe "Show page" do
    let(:level) { FactoryGirl.create(:level) }
    before { visit level_path(level) }
    
    it { should have_content(level.name) }
    it { should have_title(level.name) }
  end
  
  describe "Index page" do
    before { visit levels_path }
    
    it { should have_content('Level index') }
    it { should have_title('Level index') }
  end
end
