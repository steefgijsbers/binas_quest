require 'spec_helper'

describe "Level Pages" do
  
  subject { page }
  
  describe "Upload page" do
    before { visit upload_path }
    
    it { should have_content('Upload Levels') }
    it { should have_title(full_title('Upload Levels')) }
  
  end
end
