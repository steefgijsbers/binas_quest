require 'spec_helper'

describe "Levelpack pages" do
  
  subject { page }
  
  describe "Create page" do
    before { visit new_levelpack_path }
    
    it { should have_title(full_title('Create levelpack')) }
    it { should have_content('Create levelpack') }
  end
  
end
