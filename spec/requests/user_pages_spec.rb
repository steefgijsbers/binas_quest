require 'spec_helper'

describe "User pages" do
  
  subject {page}
  
  describe "Registreer pagina" do
    before { visit registreer_path }
    
    it { should have_content('Registreer') }
    it { should have_title(full_title('Registreer')) }
  end
  
  describe "Profiel pagina" do
    let(:user) { FactoryGirl.create(:user) }
    before {  visit user_path(user) }
    
    it { should have_content(user.naam) }
    it { should have_title(user.naam) }
  end
end
