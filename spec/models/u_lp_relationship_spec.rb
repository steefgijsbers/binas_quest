require 'spec_helper'

describe ULpRelationship do
  
  let(:user)              { FactoryGirl.create(:user) }
  let(:levelpack)         { FactoryGirl.create(:levelpack) }
  let(:u_lp_relationship) { user.u_lp_relationships.build(levelpack_id: levelpack.id) }
  
  subject { u_lp_relationship }
  
  it { should respond_to(:user) }
  it { should respond_to(:levelpack) }
  its(:user) { should eq user }
  its(:levelpack) { should eq levelpack }
  
  it { should be_valid }
  
  describe "when user_id is not present" do
    before { u_lp_relationship.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "when levelpack_id is not present" do
    before { u_lp_relationship.levelpack_id = nil }
    it { should_not be_valid }
  end
end
