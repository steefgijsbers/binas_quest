require 'spec_helper'

describe "User pages" do
  
  subject {page}
  
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

        it { should have_title(user.naam) }
        it { should have_selector('div.alert.alert-success', text: 'Welkom') }
      end
    end
  end
  
  describe "Profiel pagina" do
    let(:user) { FactoryGirl.create(:user) }
    before {  visit user_path(user) }
    
    it { should have_content(user.naam) }
    it { should have_title(user.naam) }
  end
end
