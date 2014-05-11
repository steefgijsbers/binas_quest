require 'spec_helper'

<<<<<<< HEAD
describe "StaticPages" do

  subject {page} 
  
  describe "Home page" do
      before { visit root_path }
      
      it { should have_content('Welkom') }   
      it { should have_title(full_title('')) }
      it { should_not have_title('| Home') }
=======
describe "Static Pages" do
  
  let(:user) { FactoryGirl.create(:user) }
  
  subject { page } 
  
  describe "Home page" do
    before { visit root_path } 
    it { should have_content 'Welkom' }
    it { should have_title '' }
    it { should_not have_title full_title '| Home' }
    it { should have_link 'Hoe werkt het?', href: help_path }
    it { should have_link 'Hall of Fame' }
    
    describe "for non-signed-in users" do
      it { should have_link 'Registreer', href: registreer_path }
      it { should have_link 'Log in', href: signin_path }
    end
    
    describe "for signed-in users" do
      before do 
        setup_start_for user
        sign_in user
        visit root_path
      end
      it { should have_link 'Play',    href: user_path(user) }
      it { should have_link 'Log uit', href: signout_path }
    end
>>>>>>> spec-requests
  end
  
  describe "Help page" do
    before { visit help_path }
<<<<<<< HEAD
    
    it { should have_content('Uitleg') }
    it { should have_title(full_title('Uitleg')) }
  end
  
  
  describe "Contact page" do
    before { visit contact_path }
    
    it { should have_content('Contact') }
    it { should have_title(full_title('Contact')) }
  end



=======
    it { should have_content 'Uitleg' }
    it { should have_title full_title 'Uitleg' }
  end
  
  describe "Contact page" do
    before { visit contact_path }
    it { should have_content 'Contact' }
    it { should have_title full_title 'Contact' }
  end
>>>>>>> spec-requests
end
