require 'spec_helper'

describe "User pages" do
  
  subject {page}
  
  describe "Registreer pagina" do
    before { visit registreer_path }
    
    it { should have_content('Registreer') }
    it { should have_title(full_title('Registreer')) }
  end
end
