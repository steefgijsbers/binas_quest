require 'spec_helper'

describe "User pages" do
  
  subject {page}
  
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end
    
    describe "page" do
      it { should have_title('Wijzig profiel') }
      it { should have_content('Wijzig profiel') }
    end
    
    describe "with invalid information" do
      before { click_button "Sla op" }
      
      it { should have_content 'error' }
    end
    
    describe "with valid information" do
      let(:new_naam)  { "New naam" }
      let(:new_klas)  { "1Aa" }
      let(:new_email) { "new_email@example.org" }
      before do
        fill_in "Naam",                 with: new_naam
        fill_in "Klas",                 with: new_klas
        fill_in "Email",                with: new_email
        fill_in "Wachtwoord",           with: "foobar"
        fill_in "Bevestig wachtwoord",  with: "foobar"
        click_button "Sla op"
      end
      
      it { should have_title new_naam }
      it { should have_selector 'div.alert.alert-success' }
      it { should have_link 'Log uit', href: signout_path }
      specify { expect(user.reload.naam).to  eq new_naam }
      specify { expect(user.reload.klas).to  eq new_klas }
      specify { expect(user.reload.email).to eq new_email }      
    end
  end
  
  describe "index" do
    let(:user) { FactoryGirl.create(:user, admin: true) }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.naam)
        end
      end
    end
    
    describe "delete links" do
      it { should_not have_link 'delete' }
      
      describe "as an admin user" do
        let(:admin) {FactoryGirl.create :admin }
        before do
          sign_in admin
          visit users_path
        end
        
        it { should have_link 'delete', href: user_path(User.first) }
        it "should be able to delete another user" do
          expect do
            click_link 'delete', match: :first
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link 'delete', href: user_path(admin) }
      end
    end
  end
  
  describe "Registreer pagina" do
    before { visit registreer_path }
    
    it { should have_content('Registreer') }
    it { should have_title(full_title('Registreer')) }
  end
  
  describe "Registreer" do
    before { visit registreer_path }
    let(:submit) { "Registreer" }
    
    describe "with invalid information" do      
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      
      describe "after submission" do
        before { click_button submit }
        
        it { should have_title('Registreer') }
        it { should have_content('error') }
      end
    end
    
    describe "with valid information" do
      before do
        fill_in "Naam",                 with: "Example User"
        fill_in "Klas",                 with: "5Hb"
        fill_in "Email",                with: "user@example.com"
        fill_in "Wachtwoord",           with: "foobar"
        fill_in "Bevestig wachtwoord",  with: "foobar" 
      end
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link "Log uit" }
        it { should have_title(user.naam) }
        it { should have_selector('div.alert.alert-success', text: 'Welkom') }
      end
    end
  end
  
  describe "Profiel pagina" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit user_path(user)
    end
    
    it { should have_content(user.naam) }
    it { should have_title(user.naam) }
  end
end
