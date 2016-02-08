require 'rails_helper'

RSpec.describe User, type: :ability do
  describe "with writer role" do
    let(:user) { build(:user, role: 'writer') }
    subject(:ability) { Ability.new(user) }

    it { should be_able_to(:manage, Refugee.new) }
    it { should be_able_to(:manage, Home.new) }
    it { should be_able_to(:manage, Placement.new) }
    it { should be_able_to(:manage, Relationship.new) }
    it { should be_able_to(:generate, :reports) }
    it { should be_able_to(:view, :statistics) }

    it { should_not be_able_to(:manage, Country.new) }
    it { should_not be_able_to(:manage, Gender.new) }
    it { should_not be_able_to(:manage, Language.new) }
    it { should_not be_able_to(:manage, MovedOutReason.new) }
    it { should_not be_able_to(:manage, Municipality.new) }
    it { should_not be_able_to(:manage, OwnerType.new) }
    it { should_not be_able_to(:manage, Ssn.new) }
    it { should_not be_able_to(:manage, TargetGroup.new) }
    it { should_not be_able_to(:manage, TypeOfHousing.new) }
    it { should_not be_able_to(:manage, TypeOfRelationship.new) }
    it { should_not be_able_to(:read, Country.new) }
    it { should_not be_able_to(:read, Gender.new) }
    it { should_not be_able_to(:read, Language.new) }
    it { should_not be_able_to(:read, MovedOutReason.new) }
    it { should_not be_able_to(:read, Municipality.new) }
    it { should_not be_able_to(:read, OwnerType.new) }
    it { should_not be_able_to(:read, Ssn.new) }
    it { should_not be_able_to(:read, TargetGroup.new) }
    it { should_not be_able_to(:read, TypeOfHousing.new) }
    it { should_not be_able_to(:read, TypeOfRelationship.new) }
  end
end
