require 'spec_helper'

describe "Levelpack pages" do
  
  subject { page }
  
  describe "Create page" do
    before { visit new_levelpack_path }
    
    it { should have_title(full_title('Create levelpack')) }
    it { should have_content('Create levelpack') }
  end
  
  describe "Show page" do
    let(:levelpack) { FactoryGirl.create(:levelpack) }
    before { visit levelpack_path(levelpack) }
    
    it { should have_title(full_title(levelpack.name)) }
    it { should have_content levelpack.name }
    it { should have_content levelpack.title }
    it { should have_content levelpack.solution }
  end
  
  describe "Index page" do
    before do
      visit new_levelpack_path
      fill_in "Name: (format = 'levelpack_00')", with: "levelpack_00"
      fill_in "Title: (max 50 char)",            with: "example levelpack"
      click_button 'Create levelpack'
      visit levelpacks_path
    end    
    
    it { should have_selector('li', text: "levelpack_00") }
    it { should have_title(full_title('Levelpack index')) }
    it { should have_content 'Levelpack index' }
    it { should have_link 'delete' }
  end
  
  
  describe "create levelpack" do
    before { visit new_levelpack_path }    
    let(:submit) { "Create levelpack" }
    
    describe "with invalid information" do
      it "should not create a levelpack" do
        expect { click_button submit }.not_to change(Levelpack, :count)
      end
    end
    
    describe "with valid information" do
      before do
        fill_in "Name: (format = 'levelpack_00')", with: "levelpack_00"
        fill_in "Title: (max 50 char)",            with: "example levelpack"
      end
      it "should create a levelpack" do
        expect { click_button submit }.to change(Levelpack, :count).by(1)
      end
    end
  end
end
