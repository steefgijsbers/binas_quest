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
    end
  end
  
  describe "Profiel pagina" do
    let(:user) { FactoryGirl.create(:user) }
    before {  visit user_path(user) }
    
    it { should have_content(user.naam) }
    it { should have_title(user.naam) }
  end
end
