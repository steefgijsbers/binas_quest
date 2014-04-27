require 'spec_helper'

describe "Level pages" do
  
  subject { page }
  
  let(:user)      { FactoryGirl.create(:user) }
  let(:admin)     { FactoryGirl.create(:user, admin: true) }
  let(:levelpack) { FactoryGirl.create(:levelpack) }
  
  describe "When non-admin user" do
    before { sign_in user, no_capybara: true }
    
    describe "tries to access" do
      describe "upload page" do
        before  { get new_levelpack_path }        
        specify { expect(response).to redirect_to root_url }
      end
      
      describe "show page" do
        before  { get levelpack_path(levelpack) }
        specify { expect(response).to redirect_to root_url }
      end
      
      describe "index page" do
        before  { get levelpacks_path }
        specify { expect(response).to redirect_to root_url }
      end      
    end
    
    describe "tries to upload a new level" do
      before  { post levelpacks_path(levelpack) }
      specify { expect(response).to redirect_to root_url }
    end
    
    describe "tries to delete an existing level" do
      before  { delete levelpack_path(levelpack) }
      specify { expect(response).to redirect_to root_url }
    end
  end
  
  describe "When admin tries to access" do
    before { sign_in admin }
    
    describe "upload page" do
      before { visit new_levelpack_path }
      
      it { should have_content('Create levelpack') }
      it { should have_title(full_title('Create levelpack')) }
      
      describe "and tries to create levelpack" do
        let(:submit) { 'Create levelpack' }
        
        describe "with invalid information" do
          it "should not create a new levelpack" do
            expect { click_button submit }.not_to change Level, :count
          end          
        end
        
        describe "with valid information" do
          before do
            fill_in "Name: (format = 'levelpack_00')", with: "levelpack_00"
            fill_in "Title: (max 50 char)",            with: "example title"
          end
          
          it "should create a new levelpack" do
            expect { click_button submit }.to change(Levelpack, :count).by(1)
          end
        end
      end      
    end
    
    describe "show page" do
      before { visit levelpack_path(levelpack) }
      
      it { should have_content(levelpack.name) }
      it { should have_title(levelpack.name) }
    end
    
    describe "index page" do
      before do 
        visit new_levelpack_path
        fill_in "Name: (format = 'levelpack_00')", with: "levelpack_00"
        fill_in "Title: (max 50 char)",            with: "example title"
        click_button 'Create levelpack'
        visit levelpacks_path        
      end
      
      it { should have_selector('li', text: "levelpack_00") }
      it { should have_title 'Levelpack index' }    
      it { should have_content 'Levelpack index' }  
      it { should have_link 'delete' }
      
      describe "and tries to delete an existing levelpack" do
        it "should work" do
          expect do
            click_link 'delete', match: :first          
          end.to change(Levelpack, :count).by(-1)
        end
      end
    end
  end
end
