require 'spec_helper'

describe "User Pages" do
  
  subject { page }
  
  describe "Registreer page" do   
    before { visit registreer_path }
 
    it { should have_title full_title 'Registreer' }
    it { should have_content 'Registreer' }
    
    describe "Registering" do
      let(:submit)    { 'Registreer' }
      let(:levelpack) { FactoryGirl.create :levelpack }
      let(:level_01)  { FactoryGirl.create :level, name: 'level_01' }
      let(:level_02)  { FactoryGirl.create :level, name: 'level_02' }
      
      before do
        levelpack.add! level_01
        levelpack.add! level_02
      end      
      describe "with invalid information" do
        it "should not create a new user" do
          expect{ click_button submit }.not_to change User, :count
        end
        
        describe "after submission" do
          before { click_button submit }
          it { should have_title full_title 'Registreer' }
          it { should have_content('error') }
        end
      end
      
      describe "with valid information" do
        before do
          fill_in "Naam",                with: "Example"
          fill_in "Klas",                with: "5Hb"
          fill_in "Email",               with: "example@example.org"
          fill_in "Wachtwoord",          with: "foobar"
          fill_in "Bevestig wachtwoord", with: "foobar"
        end
        it "should create a new user" do
          expect{ click_button submit }.to change(User, :count).by(1)
        end
        
        describe "after submission" do
          before { click_button submit }
          it { should have_title full_title 'Example' }
          it { should have_selector('div.alert.alert-success', text: 'Welkom') }
          it { should have_link 'Log uit', href: signout_path }
        end
      end      
    end
  end
  
  describe "Edit page" do
    let(:user) { FactoryGirl.create :user }
    before do
      setup_start_for user
      sign_in user
      visit edit_user_path(user)
    end
    it { should have_title full_title 'Wijzig profiel' }
    it { should have_content 'Wijzig profiel' }
    
    describe "Editing" do
      let(:submit) { 'Sla op' }
      
      describe "with invalid information" do
        before { click_button submit }
        it { should have_title full_title "Wijzig profiel" }
        it { should have_content 'error' }       
      end
      
      describe "with valid information" do
        let(:new_naam)  { 'example' }
        let(:new_klas)  { '1Aa' }
        let(:new_email) { 'user@example.org' }
        
        before do
          fill_in "Naam",                with: new_naam
          fill_in "Klas",                with: new_klas
          fill_in "Email",               with: new_email
          fill_in "Wachtwoord",          with: "foobar"
          fill_in "Bevestig wachtwoord", with: "foobar" 
          click_button submit
        end
        it { should have_title full_title new_naam }        
        it { should have_selector 'div.alert.alert-success' }
        specify{ expect(user.reload.naam).to eq new_naam }                      
        specify{ expect(user.reload.klas).to eq new_klas }                        
        specify{ expect(user.reload.email).to eq new_email }       
      end
    end
  end
  
  describe "Show page" do
    let(:user) { FactoryGirl.create :user }
    before do
      setup_start_for user
      sign_in user
      visit user_path(user)
    end
    
    it { should have_title full_title user.naam }
    it { should have_link user.unlocked_levelpacks.first.title }
    it { should have_link user.unlocked_levelpacks.last.title }
    it { should have_selector 'h3', user.unlocked_levelpacks.first.title }
    it { should have_selector 'section#levelpack_thumbs' }
    it { should have_selector 'section#level_image' }
    it { should have_selector 'section#enter_solution_form' }
    
    describe "clicking on a levelpack link" do
      before { click_link user.unlocked_levelpacks.last.title }      
      it { should have_selector 'h3', user.unlocked_levelpacks.last.title }
      it { should_not have_selector 'div.admin_sidebar' }
    end
    
    describe "clicking on a level_thumb" do
      let(:level1) { Level.find_by_name "level1" }
      before { find(:xpath, "//a/img[contains(@src, #{level1.thumb_src})]/..", match: :first).click }
      it { should have_selector 'h3', user.unlocked_levelpacks.first.title }
      it { should_not have_selector 'div.admin_sidebar' }
      it { should have_xpath("//img[contains(@src, #{level1.img_src})]") }
    end
    
    describe "submitting a solution" do
      let(:submit) { 'Check' }
      describe "which is incorrect" do
        it "should not unlock a new levelpack" do
          expect{ click_button submit }.not_to change(user.unlocked_levelpacks, :count)
        end
        it "should not change the view" do
          click_link user.unlocked_levelpacks.first.title
          click_button submit
          expect(page).to have_content user.unlocked_levelpacks.first.title
        end
        
      end
    end
  end
  
  describe "Index page" do

  end
end