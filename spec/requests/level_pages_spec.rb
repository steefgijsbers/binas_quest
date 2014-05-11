require 'spec_helper'

describe "Level Pages" do
  
  subject { page }
  
  let(:admin) { FactoryGirl.create(:user, admin: true) }
  let(:level) { FactoryGirl.create(:level) }
  
  describe "When admin visits the" do
    before do
      setup_start_for admin
      sign_in admin
    end
    
    describe "upload page" do
      before { visit uploadlevels_path }
      
      it { should have_title full_title 'Upload level' }
      it { should have_content 'Upload level to database' }
      
      describe "and tries to upload a level" do
        let(:submit) { 'Upload level' }
        
        describe "with invalid information" do
          it "should not create a new level" do
            expect{ click_button submit }.not_to change(Level, :count)
          end
        end
        
        describe "with valid information" do
          let(:new_level) { Level.new(name: "new_level", img_src: "new_level.bmp", solution: "na") }
          before do
            fill_in "Name",         with: new_level.name
            fill_in "Image source", with: new_level.img_src
            fill_in "Solution",     with: new_level.solution
          end
          it "should create a new level" do
            expect{ click_button submit }.to change(Level, :count).by(1)
          end
          
          describe ", it should redirect admin to the show page of level" do
            before { click_button submit }
            it { should have_content new_level.name }
            
            describe ", which also shows level.thumb_src" do
              it { should have_content new_level.thumb_src }
            end
          end          
        end
      end
    end
    
    describe "show page" do
      before { visit level_path(level) }
      
      it { should have_title full_title level.name }
      it { should have_selector('li', level.name) }
      it { should have_selector('li', level.img_src) }
      it { should have_selector('li', level.thumb_src) }
      it { should have_selector('li', level.solution) }
      it { should have_link('Level index',      href: levels_path) }
      it { should have_link('Upload new level', href: uploadlevels_path) }
      it { should have_selector('img', level.img_src) }
    end
    
    describe "index page" do
      let(:new_level) { Level.new(name: "new_level", img_src: "new_level.bmp", solution: "na") }
      before do
        visit uploadlevels_path
        fill_in "Name",         with: new_level.name
        fill_in "Image source", with: new_level.img_src
        fill_in "Solution",     with: new_level.solution
        click_button 'Upload level'
        visit levels_path
      end
      it { should have_link new_level.name, href: level_path(Level.find_by_name new_level.name) }
      it { should have_link 'Delete', href: level_path(Level.find_by_name new_level.name) }
      
      describe "and tries to delete an existing level" do
        it "should work" do
          expect do
            click_link 'Delete', match: :first
          end.to change(Level, :count).by(-1)
        end
      end      
    end
  end
end
