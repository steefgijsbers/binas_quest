require 'spec_helper'

describe "Levelpack Pages" do
  
  let(:level_01)  { FactoryGirl.create(:level, name: "level 01") }
  let(:level_02)  { FactoryGirl.create(:level, name: "level 02") }
  let(:admin)     { FactoryGirl.create(:user, admin: true) }
  
  subject { page }
  
  describe "When admin tries to access" do
    before do
      setup_start_for admin
      sign_in admin
    end
    
    describe "Create page" do
      before { visit new_levelpack_path }
      it { should have_title full_title 'Create levelpack' }
      it { should have_content 'Create levelpack' }
      it { should have_content '1st level' }
      it { should have_content '2nd level' }
      it { should have_content '3rd level' }
      it { should have_content '4th level' }
      it { should have_content '5th level' }
      
      describe "and tries to create a levelpack" do
        let(:submit) { 'Create levelpack' }
        
        describe "with invalid information" do
          it "should not create a new levelpack" do
            expect{ click_button submit }.not_to change Levelpack, :count
          end
        end
        
        describe "with valid information" do
           
          before do
            @levelpack = Levelpack.new name: "levelpack_99", title: "example levelpack"
            fill_in 'Name',  with: @levelpack.name
            fill_in 'Title', with: @levelpack.title
          end
          
          describe ", but without adding levels" do
            it "should create a new levelpack" do
              expect{ click_button submit }.to change(Levelpack, :count).by(1)
            end
            
            describe "the levelpack solution should be blank" do
              before  { click_button submit }
              specify { expect(@levelpack.solution).to be_nil }
            end
            
            describe "it should redirect to show page of levelpack" do
              before { click_button submit }
              it { should have_title full_title @levelpack.title }
            end     
          end  
          
          describe ", and adding two levels" do
            before do
              fill_in '1st level', with: level_01.name
              fill_in '2nd level', with: level_02.name
            end
            
            it "should create a new levelpack" do
              expect{ click_button submit }.to change(Levelpack, :count).by(1)
            end
            
            describe "the levelpack" do
              before do
                click_button submit
                @saved_levelpack = Levelpack.find_by_name @levelpack.name
              end
              
              it "should have solution equal to solution of two levels" do
                expect(@saved_levelpack.solution).to eq level_01.solution + level_02.solution
              end
              
              it "should have the first level in its corresponding levels" do
                expect(@saved_levelpack.corresponding_levels.first.name).to eq level_01.name
              end
              
              it "should have the second level in its corresponding levels" do
                expect(@saved_levelpack.corresponding_levels.last.name).to eq level_02.name
              end                
            
              it { should have_title @levelpack.title }           
            end
          end                                                                         
        end
      end
    end
    
    describe "Edit page" do
      before do
        @levelpack = FactoryGirl.create :levelpack
        @levelpack.add! level_01
        @levelpack.update_solution
        visit edit_levelpack_path(@levelpack)
      end
      
      
      it { should have_title full_title 'Edit levelpack' }
      it { should have_content 'Edit levelpack' }
      it { should have_content @levelpack.name }
      it { should have_content '1st level' }
      it { should have_content '2nd level' }
      it { should have_content '3rd level' }
      it { should have_content '4th level' }
      it { should have_content '5th level' }
      
      it "should have '1st level' input field prefilled with level_01 name" do
        find_field('1st level').value.should eq level_01.name
      end
      
      describe "and tries to edit the title of the levelpack" do
        let(:submit) { 'Save levelpack' }
        before { fill_in 'Title', with: "another title" }
        
        it "should not create nor delete a levelpack" do
          expect{ click_button submit }.not_to change Levelpack, :count
        end
        
        describe "without trying to change the levels" do
          before { click_button submit }
          it { should have_title full_title "another title" }
        end
        
        describe "and tries to change the levels" do
          before do
            fill_in '1st', with: ""
            fill_in '2nd', with: level_02.name
            click_button submit
          end
          it { should have_title full_title "another title" }
          
          describe ", the editted levelpack" do
            before { @edited_levelpack = Levelpack.find_by_name @levelpack.name }
            it "should have only level_02 in its pack" do
              expect(@edited_levelpack.corresponding_levels.first.name).to eq level_02.name
              expect(@edited_levelpack.corresponding_levels.last.name).to  eq level_02.name
            end
            it "should have the correct solution" do
              expect(@edited_levelpack.solution).to eq level_02.solution
            end
          end
        end        
      end
    end
    
    describe "Show page" do
      before do
        @levelpack =      FactoryGirl.create :levelpack, name: "levelpack_51"
        @next_levelpack = FactoryGirl.create :levelpack, name: "levelpack_52"
        @levelpack.add! level_01
        @levelpack.add! level_02
        @levelpack.update_solution
        level_01.update_attributes(img_src: "level01.jpg", thumb_src: "level01thumb.jpg")
        level_02.update_attributes(img_src: "level02.jpg", thumb_src: "level02thumb.jpg")
        visit levelpack_path(@levelpack)
      end
      
      it { should have_title full_title @levelpack.title }
      #sidebar info:
      it { should have_content 'Levelpack info' }
      it { should have_content @levelpack.name }
      it { should have_content @levelpack.title }
      it { should have_link level_01.name, href: level_path(level_01) }
      it { should have_link level_02.name, href: level_path(level_02) }
      it { should have_content @levelpack.solution }
      it { should have_link 'Edit',   href: edit_levelpack_path(@levelpack) }
      it { should have_link 'Delete', href: levelpack_path(@levelpack) }
      
      #puzzle_mode:
      describe "and clicks the level_01 thumb" do
        before { find(:xpath, "//a/img[contains(@src, #{level_01.thumb_src})]/..", match: :first).click }
        it { should have_xpath("//img[contains(@src, #{level_01.img_src})]") }
      end
      
      describe "and clicks the level_02 thumb" do
        before { find(:xpath, "//a/img[contains(@src, #{level_02.thumb_src})]/..", match: :first).click }
        it { should have_xpath("//img[contains(@src, #{level_02.img_src})]") }
      end
      
      describe "and tries to enter solution" do
        let(:correct_solution) { level_01.solution + level_02.solution }
        let(:incorrect_solutions) { [level_01.solution, level_02.solution, " ", correct_solution + " ", " " + correct_solution] }
        let(:submit) { 'Check' }
        describe "which is incorrect" do
          it "should be incorrect" do
            incorrect_solutions.each do |incorrect_solution|
              fill_in "Antwoord:", with: incorrect_solution
              expect{ click_button submit }.not_to change(admin.unlocked_levelpacks, :count)
            end
            click_button submit
            expect(page).to have_title full_title @levelpack.title
          end          
        end
        
        describe "which is correct" do
          it "should be correct" do
            fill_in "Antwoord:", with: correct_solution
            expect{ click_button submit }.to change(admin.unlocked_levelpacks, :count).by(1)
          end
        end
      end
      
      describe "if levelpack does not contain levels" do
        before do
          @levelpack.remove! level_01
          @levelpack.remove! level_02
          visit levelpack_path(@levelpack)
        end
        it { should_not have_xpath("//a/img[contains(@src, #{level_01.thumb_src})]/..") }
        it { should_not have_xpath("//a/img[contains(@src, #{level_02.thumb_src})]/..") }
        it { should_not have_selector 'img' }
        it { should have_content 'Levelpack does not contain any levels' }
      end
    end
    
    describe "Index page" do
      before do
        @levelpack = FactoryGirl.create :levelpack
        visit levelpacks_path
      end
      it { should have_title 'Levelpack index' }
      it { should have_content 'Levelpack index' }
      it { should have_link @levelpack.name, href: levelpack_path(@levelpack) }
      it { should have_link 'Delete',        href: levelpack_path(@levelpack) }  
      
      describe "and tries to acces a levelpack show page by clicking the link" do
        before { click_link @levelpack.name }
        it { should have_title full_title @levelpack.title }
      end
      
      describe "and tries to delete an exisiting levelpack" do
        it "should work" do
          expect do
            click_link 'Delete', match: :first
          end.to change(Levelpack, :count).by(-1)
        end
        it "should redirect to the index page" do
          expect(page).to have_title full_title 'Levelpack index'
        end
      end      
    end
  end  
end
