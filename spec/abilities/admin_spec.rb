require 'rails_helper'

RSpec.describe User, type: :ability do
  describe "with admin role" do
    let(:user) { build(:user, role: 'admin') }
    subject(:ability) { Ability.new(user) }

    it { should be_able_to(:manage, Country.new) }
    it { should be_able_to(:manage, Gender.new) }
    it { should be_able_to(:manage, Language.new) }
    it { should be_able_to(:manage, MovedOutReason.new) }
    it { should be_able_to(:manage, Municipality.new) }
    it { should be_able_to(:manage, OwnerType.new) }
    it { should be_able_to(:manage, Ssn.new) }
    it { should be_able_to(:manage, TargetGroup.new) }
    it { should be_able_to(:manage, TypeOfHousing.new) }
    it { should be_able_to(:manage, TypeOfRelationship.new) }
    it { should be_able_to(:read, Country.new) }
    it { should be_able_to(:read, Gender.new) }
    it { should be_able_to(:read, Language.new) }
    it { should be_able_to(:read, MovedOutReason.new) }
    it { should be_able_to(:read, Municipality.new) }
    it { should be_able_to(:read, OwnerType.new) }
    it { should be_able_to(:read, Ssn.new) }
    it { should be_able_to(:read, TargetGroup.new) }
    it { should be_able_to(:read, TypeOfHousing.new) }
    it { should be_able_to(:read, TypeOfRelationship.new) }

    it { should be_able_to(:manage, Refugee.new) }
    it { should be_able_to(:manage, Home.new) }
    it { should be_able_to(:manage, Placement.new) }
    it { should be_able_to(:manage, Relationship.new) }
    it { should be_able_to(:generate, :reports) }

    it { should be_able_to(:read, Refugee.new) }
    it { should be_able_to(:read, Home.new) }
    it { should be_able_to(:read, Placement.new) }
    it { should be_able_to(:read, Relationship.new) }
    it { should be_able_to(:view, :statistics) }

    it { should_not be_able_to(:destroy, Refugee.new) }
    it { should_not be_able_to(:destroy, Home.new) }
  end
end
