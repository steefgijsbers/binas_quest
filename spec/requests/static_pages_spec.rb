require 'spec_helper'

describe "StaticPages" do

  describe "Home page" do
      
      it "should have content 'Welkom'" do
        visit '/static_pages/home'
        expect(page).to have_content('Welkom')
      end    
      it "should have the base title 'Binas Quest'" do
        visit '/static_pages/home'
        expect(page).to have_title('Binas Quest')
      end
      it "should not have a custom page title'" do
        visit '/static_pages/home'
        expect(page).not_to have_title('| Home')
      end
  end
  
  
  describe "Help page" do
    
    it "should have content 'Uitleg'" do
      visit '/static_pages/help'
      expect(page).to have_content('Uitleg')
    end
    it "should have title 'Uitleg'" do
      visit '/static_pages/help'
      expect(page).to have_title('Binas Quest | Uitleg')
    end
  end
  
  
  describe "Contact page" do
    
    it "should have content 'Contact'" do
      visit '/static_pages/contact'
      expect(page).to have_content('Contact')     
    end
    it "should have title 'Binas Quest | Contact'" do
      visit '/static_pages/contact'
      expect(page).to have_title('Binas Quest | Contact')
    end
  end



end
