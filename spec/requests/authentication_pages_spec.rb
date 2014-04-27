require 'spec_helper'

describe "AuthenticationPages" do
  
  subject { page }
  
  describe "Authorisation" do
    
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      
      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",      with: user.email
          fill_in "Wachtwoord", with: user.password
          click_button "Log in"
        end
        
        describe "after signing in" do
          it "should render the desired protected page" do
            expect(page).to have_title('Wijzig profiel')
          end
        end
      end
      
      describe "in the Users controller" do
        
        describe "visiting the show page" do
          before { visit user_path(user) }
          it { should have_title 'Log in' }
        end
        
        describe "visiting the index page" do
          before { visit users_path }
          it { should have_title 'Log in' }
        end
        
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title 'Log in' }
        end
        
        describe "submitting to the update page" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to signin_path }
        end
      end
      
      
      describe "in the Levelpacks controller" do
        let(:levelpack) { FactoryGirl.create(:levelpack) }
        
        describe "visiting the new page" do
          before { visit new_levelpack_path }
          it { should have_title 'Log in' }
        end
        
        describe "visiting the show page" do          
          before { visit levelpack_path(levelpack) }
          it { should have_title 'Log in' }
        end
        
        describe "visiting the index page" do
          before { visit levelpacks_path }
          it { should have_title 'Log in' }
        end
        
        describe "submitting to the create page" do
          before { post levelpacks_path }
          specify { expect(response).to redirect_to signin_path }
        end
      end
    end
    
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.org") }
      before { sign_in user, no_capybara: true }
      
      describe "submitting a GET request to the User#show action" do
        before { get user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title(user.naam)) }
        specify { expect(response).to redirect_to signin_url }
      end
      
      describe "submitting a GET request to the User#edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Wijzig profiel')) }   
        specify { expect(response).to redirect_to signin_url }     
      end
      
      describe "submitting a PATCH request to the User#update action" do
        before { patch user_path(wrong_user) }
        specify{ expect(response).to redirect_to signin_url }
      end
    end    
  end
  
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
      it { should have_link('Status',         href: user_path(user)) }
      it { should have_link('Wijzig profiel', href: edit_user_path(user)) }
      it { should have_link('Log uit',        href: signout_path) }
      it { should_not have_link('Log in',     href: signin_path) }
      
      describe "as non-admin user" do
        it { should_not have_link('All users',        href: users_path) }
        it { should_not have_link('Level index',      href: levels_path) }
        it { should_not have_link('Level upload',     href: uploadlevels_path) }
        it { should_not have_link('Levelpack index',  href: levelpacks_path) }
        it { should_not have_link('Levelpack create', href: new_levelpack_path) }
      end
      
      describe "as admin user" do
        before do
          user.update_attribute(:admin, true)
          visit user_path(user)
        end
        it { should have_link('All users',        href: users_path) }
        it { should have_link('Level index',      href: levels_path) }
        it { should have_link('Level upload',     href: uploadlevels_path) }
        it { should have_link('Levelpack index',  href: levelpacks_path) }
        it { should have_link('Levelpack create', href: new_levelpack_path) }
      end
      
      describe "followed by sign-out" do
        before { click_link "Log uit" }
        
        it { should have_link "Log in" }
      end
    end
    
    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }
      
      before { sign_in non_admin, no_capybara: true }
      
      describe "submitting a GET request to the Users action" do
        before { get users_path }
        specify { expect(response).to redirect_to root_url }  
      end
      
      describe "submitting a DELETE request to the User#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to root_url }
      end
    end
  end
end
