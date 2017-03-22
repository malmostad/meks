require 'rails_helper'

RSpec.describe User, type: :ability do
  describe "with reader role" do
    let(:user) { build(:user, role: 'reader') }
    let(:refugee) { create(:refugee, name: 'bar') }
    let(:drafted_refugee) { create(:refugee, name: 'foo', draft: true) }
    subject(:ability) { Ability.new(user) }

    it { should_not be_able_to(:manage, Country.new) }
    it { should_not be_able_to(:manage, Gender.new) }
    it { should_not be_able_to(:manage, Language.new) }
    it { should_not be_able_to(:manage, MovedOutReason.new) }
    it { should_not be_able_to(:manage, LegalCode.new) }
    it { should_not be_able_to(:manage, DeregisteredReason.new) }
    it { should_not be_able_to(:manage, Municipality.new) }
    it { should_not be_able_to(:manage, OwnerType.new) }
    it { should_not be_able_to(:manage, Ssn.new) }
    it { should_not be_able_to(:manage, TargetGroup.new) }
    it { should_not be_able_to(:manage, TypeOfHousing.new) }
    it { should_not be_able_to(:manage, TypeOfRelationship.new) }
    it { should_not be_able_to(:manage, RateCategory.new) }
    it { should_not be_able_to(:read, Country.new) }
    it { should_not be_able_to(:read, Gender.new) }
    it { should_not be_able_to(:read, Language.new) }
    it { should_not be_able_to(:read, MovedOutReason.new) }
    it { should_not be_able_to(:read, LegalCode.new) }
    it { should_not be_able_to(:read, DeregisteredReason.new) }
    it { should_not be_able_to(:read, Municipality.new) }
    it { should_not be_able_to(:read, OwnerType.new) }
    it { should_not be_able_to(:read, Ssn.new) }
    it { should_not be_able_to(:read, TargetGroup.new) }
    it { should_not be_able_to(:read, TypeOfHousing.new) }
    it { should_not be_able_to(:read, TypeOfRelationship.new) }
    it { should_not be_able_to(:manage, Refugee.new) }
    it { should_not be_able_to(:manage, Home.new) }
    it { should_not be_able_to(:manage, Placement.new) }
    it { should_not be_able_to(:manage, Relationship.new) }
    it { should_not be_able_to(:generate, :reports) }

    it { should be_able_to(:read, build(:refugee)) }
    it { should be_able_to(:read, build(:home)) }
    it { should be_able_to(:read, build(:placement)) }
    it { should be_able_to(:read, build(:relationship)) }
    it { should be_able_to(:view, :statistics) }
    it { should be_able_to(:edit, drafted_refugee) }
    it { should be_able_to(:update, drafted_refugee) }
    it { should be_able_to(:drafts, drafted_refugee) }
    it { should be_able_to(:manage, build(:placement, refugee: drafted_refugee))}
    it { should be_able_to(:manage, build(:relationship, refugee_id: drafted_refugee.id)) }
  end
end
