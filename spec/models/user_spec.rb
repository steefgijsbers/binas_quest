require 'spec_helper'

describe User do
  
  let(:user) { FactoryGirl.create(:user) }
  
  subject { user }
  
  it { should respond_to :id }
  it { should respond_to :naam }
  it { should respond_to :klas }
  it { should respond_to :email }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :password_digest }
  it { should respond_to :remember_token }
  it { should respond_to :authenticate }
  it { should respond_to :admin }
  it { should respond_to :u_lp_relationships }
  it { should respond_to :unlocked_levelpacks }
  it { should respond_to :unlock! }
  it { should respond_to :unlock_levelpack_following }
  it { should respond_to :containing? }
  it { should respond_to :name_of_next }
  
  it { should be_valid }
  it { should_not be_admin }

# admin attribute #
  
  describe "with admin attribute set to true" do
    before { user.toggle :admin }
    it { should be_admin }
  end

# remember_token attribute #
  
  describe "remember_token should not be blank" do
    its(:remember_token) { should_not be_blank }
  end

# naam attribute #
  
  describe "when naam is not present" do
    before { user.naam = " " }
    it { should_not be_valid }
  end
  
  describe "when naam is too long" do
    before { user.naam = "a" * 51 }
    it { should_not be_valid }
  end
  
# klas attribute #

  describe "when klas is not present" do
    before { user.klas = " " }
    it { should_not be_valid }
  end
  
  describe "when klas does not have the correct format" do
    it "should not be valid" do
      wrong_klas_formats = %w[7Ha 1Da 1G3 b3Va 1Gbb]
      wrong_klas_formats.each do |wrong_klas|
        user.klas = wrong_klas
        expect(user).not_to be_valid
      end
    end
  end
  
  describe "when klas has the correct format" do
    it "should be valid" do
      correct_klas_formats = %w[1Ga 6Vb 5Hb]
      correct_klas_formats.each do |correct_klas|
        user.klas = correct_klas
        expect(user).to be_valid
      end
    end
  end

# email attribute #
  
  describe "when email is not present" do
    before { user.email = " " }
    it { should_not be_valid }
  end
  
  describe "when email does not have the correct format" do
    it "should not be valid" do
      invalid_addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user).not_to be_valid
      end
    end
  end
  
  describe "when email has the correct format" do
    it "should be valid" do
      valid_addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      valid_addresses.each do |valid_address|
        user.email = valid_address
        expect(user).to be_valid
      end
    end
  end
  
  describe "when email address has mixed cases" do
    let(:mixed_case_email) { "abC@exAmPle.Org" }
    it "should be saved all lowercase" do     
      user_mixed_email = FactoryGirl.create(:user, email: mixed_case_email)
      downcase_email = mixed_case_email.downcase
      expect(downcase_email).to eq user_mixed_email.email
    end
  end
  
  describe "when email is already taken" do
    it "should not be valid" do
      user1 = FactoryGirl.create(:user, email: "a@example.org")
      user2 = User.new(naam: "A", email: "A@exaMple.oRg", klas: "5Hb", password: "foobar",
                                                                       password_confirmation: "foobar",
                                                                       admin: false)
      expect(user2).not_to be_valid
    end    
  end

# password attribute #
  
  describe "when password is not present" do
    before do
      user.password = " "
      user.password_confirmation = " "
    end
    it { should_not be_valid }
  end
  
  describe "when password is too short" do
    before { user.password = user.password_confirmation = "a" * 5 }
    it { should_not be_valid }
  end
  
  describe "when password does not match password_confirmation" do
    before { user.password_confirmation = "aaaaaa" }
    it { should_not be_valid }
  end
  
  describe "return value of authenticate method" do
    let(:found_user) { User.find_by_email user.email }
    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
    
    describe "with valid password" do
      it { should eq found_user.authenticate(user.password) }
    end
  end
  
  # user - levelpack relationships #
  
  describe "after unlocking levelpack" do
    let(:levelpack_1) { FactoryGirl.create(:levelpack, name: "levelpack_01") }
    before { user.unlock! levelpack_1 }
    it { should be_containing(levelpack_1) }
    its(:unlocked_levelpacks) { should include(levelpack_1) }
    
    describe "by completing a levelpack" do
      let!(:levelpack_2) { FactoryGirl.create(:levelpack, name: "levelpack_02") }
      before { user.unlock_levelpack_following(levelpack_1) }
      it { should be_containing(levelpack_2) }
      its(:unlocked_levelpacks) { should include(levelpack_2) }        
    end
  end
end