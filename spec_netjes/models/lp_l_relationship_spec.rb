require 'spec_helper'

describe LpLRelationship do
  
  let(:levelpack) { FactoryGirl.create(:levelpack) }
  let(:level)     { FactoryGirl.create(:level) }
  let(:lp_l_relationship) { levelpack.lp_l_relationships.build(level_id: level.id) }
  
  subject { lp_l_relationship }

  it { should respond_to :levelpack }
  it { should respond_to :level }
  its(:levelpack) { should eq levelpack }
  its(:level)     { should eq level }  
  
  it { should be_valid }
  
  describe "when levelpack_id is not present" do
    before { lp_l_relationship.levelpack_id = nil }
    it { should_not be_valid }
  end
  
  describe "when level_id is not present" do
    before { lp_l_relationship.level_id = nil }
    it { should_not be_valid }
  end
end
