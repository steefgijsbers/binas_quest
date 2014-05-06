require 'spec_helper'

describe "Level pages" do
  
  subject { page }
  
  let(:user)  { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, admin: true) }
  let(:level) { FactoryGirl.create(:level) }
  
  describe "When non-admin user" do
    before { sign_in user, no_capybara: true }
    
    describe "tries to access" do
      describe "upload page" do
        before  { get uploadlevels_path }        
        specify { expect(response).to redirect_to root_url }
      end
      
      describe "show page" do
        before { get level_path(level) }
        specify { expect(response).to redirect_to root_url }
      end
      
      describe "index page" do
        before { get levels_path }
        specify { expect(response).to redirect_to root_url }
      end      
    end
    
    describe "tries to upload a new level" do
      before { post levels_path(level) }
      specify { expect(response).to redirect_to root_url }
    end
    
    describe "tries to delete an existing level" do
      before { delete level_path(level) }
      specify { expect(response).to redirect_to root_url }
    end
  end
  
  describe "When admin tries to access" do
    before { sign_in admin }
    
    describe "upload page" do
      before { visit uploadlevels_path }
      
      it { should have_content('Upload Levels') }
      it { should have_title(full_title('Upload Levels')) }
      
      describe "and tries to upload level" do
        let(:submit) { 'Upload level' }
        
        describe "with invalid information" do
          it "should not create a new level" do
            expect { click_button submit }.not_to change Level, :count
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
    end
    
    describe "show page" do
      before { visit level_path(level) }
      
      it { should have_content(level.name) }
      it { should have_title(level.name) }
    end
    
    describe "index page" do
      before do 
        visit uploadlevels_path
        fill_in "name",     with: "Example level"
        fill_in "img_src",  with: "example.bmp"
        fill_in "solution", with: "he"
        click_button 'Upload level'
        visit levels_path        
      end
      
      it { should have_selector('li', text: "example level") }
      it { should have_title 'Level index' }    
      it { should have_content 'Level index' }  
      it { should have_link 'delete' }
      
      describe "and tries to delete an existing level" do
        it "should work" do
          expect do
            click_link 'delete', match: :first          
          end.to change(Level, :count).by(-1)
        end
      end
    end
  end
end
