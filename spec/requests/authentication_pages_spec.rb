require 'spec_helper'

describe "AuthenticationPages" do
  
  subject { page }
  
  describe "Sign in page" do
    before { visit signin_path }
    
    it { should have_content('Log in') }
    it { should have_title('Log in') }
  end
  
  describe "signin" do
    before { visit signin_path }
    
    describe "with invalid information" do
      before { click_button 'Log in' }
      
      it { should have_title('Log in') }
      it { should have_selector('div.alert.alert-error') }
      
      describe "after visiting another page" do
        before { click_link "Home" }
        
        it { should_not have_selector('div.alert.alert-error') }
      end
    end
    
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",      with: user.email.upcase
        fill_in "Wachtwoord", with: user.password
        click_button "Log in"
      end
      
      it { should have_title(user.naam) }
      it { should have_link('Status',     href: user_path(user)) }
      it { should have_link('Log uit',    href: signout_path) }
      it { should_not have_link('Log in', href: signin_path) }
      
      describe "followed by sign-out" do
        before { click_link "Log uit" }
        
        it { should have_link "Log in" }
      end
    end
  end
end
