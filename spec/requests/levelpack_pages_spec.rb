require 'spec_helper'

describe "Level pages" do

  subject { page }

  let(:user)      { FactoryGirl.create(:user) }
  let(:admin)     { FactoryGirl.create(:user, admin: true) }
  let(:levelpack) { FactoryGirl.create(:levelpack) }

  describe "When non-admin user" do
    before { sign_in user, no_capybara: true }

    describe "tries to access" do
      describe "upload page" do
        before  { get new_levelpack_path }
        specify { expect(response).to redirect_to root_url }
      end

      describe "show page" do
        before  { get levelpack_path(levelpack) }
        specify { expect(response).to redirect_to root_url }
      end

      describe "index page" do
        before  { get levelpacks_path }
        specify { expect(response).to redirect_to root_url }
      end
    end

    describe "tries to upload a new level" do
      before  { post levelpacks_path(levelpack) }
      specify { expect(response).to redirect_to root_url }
    end

    describe "tries to delete an existing level" do
      before  { delete levelpack_path(levelpack) }
      specify { expect(response).to redirect_to root_url }
    end
  end

  describe "When admin tries to access" do
    before { sign_in admin }

    describe "upload page" do
      before { visit new_levelpack_path }

      it { should have_content('Create levelpack') }
      it { should have_title(full_title('Create levelpack')) }
      it { should have_content('1st level in levelpack') }
      it { should have_content('2nd level in levelpack') }
      it { should have_content('3rd level in levelpack') }
      it { should have_content('4th level in levelpack') }
      it { should have_content('5th level in levelpack') }

      describe "and tries to create levelpack" do
        let(:submit) { 'Create levelpack' }

        describe "with invalid information" do
          it "should not create a new levelpack" do
            expect { click_button submit }.not_to change Levelpack, :count
          end
        end

        describe "with valid information" do
          let(:level1) { FactoryGirl.create(:level, name: "level1") }
          let(:level2) { FactoryGirl.create(:level, name: "level2") }
          before do
            fill_in "Name: (format = 'levelpack_00')", with: "levelpack_00"
            fill_in "Title: (max 50 char)",            with: "example title"
            fill_in "1st level in levelpack",          with: level1.name
            fill_in "2nd level in levelpack",          with: level2.name
          end

          it "should create a new levelpack" do
            expect { click_button submit }.to change(Levelpack, :count).by(1)
          end
        end
      end
    end

    describe "show page" do
      before { visit levelpack_path(levelpack) }

      it { should have_content(levelpack.name) }
      it { should have_title(levelpack.name) }
      it { should have_link('Edit levelpack', href: edit_levelpack_path(levelpack))}
    end

    describe "edit page" do
      before { visit edit_levelpack_path(levelpack) }

      it { should have_content('Edit levelpack') }
      it { should have_title(full_title('Edit levelpack')) }
      it { should have_content('1st level in levelpack') }
      it { should have_content('2nd level in levelpack') }
      it { should have_content('3rd level in levelpack') }
      it { should have_content('4th level in levelpack') }
      it { should have_content('5th level in levelpack') }

      describe "and tries to edit levelpack" do
        let(:submit) { 'Save levelpack' }

        describe "with valid information" do
          let(:level1) { FactoryGirl.create(:level, name: "level 1") }
          let(:level2) { FactoryGirl.create(:level, name: "level 2") }
          before do
            fill_in "Title: (max 50 char)",            with: "example title"
            fill_in "1st level in levelpack",          with: level1.name
            fill_in "2nd level in levelpack",          with: level2.name
            click_button submit
          end
          
          it { should have_content levelpack.name }
          it { should have_selector('li', text: level1.name) }
          it { should have_selector('li', text: level2.name) }        
        end
      end
    end

    describe "index page" do
      before do
        visit new_levelpack_path
        fill_in "Name: (format = 'levelpack_00')", with: "levelpack_00"
        fill_in "Title: (max 50 char)",            with: "example title"
        click_button 'Create levelpack'
        visit levelpacks_path
      end

      it { should have_selector('li', text: "levelpack_00") }
      it { should have_title 'Levelpack index' }
      it { should have_content 'Levelpack index' }
      it { should have_link 'delete' }

      describe "and tries to delete an existing levelpack" do
        it "should work" do
          expect do
            click_link 'delete', match: :first
          end.to change(Levelpack, :count).by(-1)
        end
      end
    end
  end
end
