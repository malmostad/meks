RSpec.describe User, type: :ability do
  describe 'with reader role' do
    subject(:ability) { Ability.new(user) }

    let(:user) { build(:user, role: 'reader') }
    let(:refugee) { create(:refugee) }
    let(:drafted_refugee) { create(:refugee, draft: true) }
    let(:drafted_placement) { create(:placement, refugee: drafted_refugee) }

    it { should_not be_able_to(:manage, Country.new) }
    it { should_not be_able_to(:manage, DeregisteredReason.new) }
    it { should_not be_able_to(:manage, ExtraContribution.new) }
    it { should_not be_able_to(:manage, ExtraContributionType.new) }
    it { should_not be_able_to(:manage, FamilyAndEmergencyHomeCost.new) }
    it { should_not be_able_to(:manage, Gender.new) }
    it { should_not be_able_to(:manage, Home.new) }
    it { should_not be_able_to(:manage, Language.new) }
    it { should_not be_able_to(:manage, LegalCode.new) }
    it { should_not be_able_to(:manage, MovedOutReason.new) }
    it { should_not be_able_to(:manage, Municipality.new) }
    it { should_not be_able_to(:manage, OwnerType.new) }
    it { should_not be_able_to(:manage, Payment.new) }
    it { should_not be_able_to(:manage, PaymentImport.new) }
    it { should_not be_able_to(:manage, Placement.new) }
    it { should_not be_able_to(:manage, Rate.new) }
    it { should_not be_able_to(:manage, RateCategory.new) }
    it { should_not be_able_to(:manage, Refugee.new) }
    it { should_not be_able_to(:manage, RefugeeExtraCost.new) }
    it { should_not be_able_to(:manage, Relationship.new) }
    it { should_not be_able_to(:manage, Ssn.new) }
    it { should_not be_able_to(:manage, Setting.new) }
    it { should_not be_able_to(:manage, TargetGroup.new) }
    it { should_not be_able_to(:manage, TypeOfHousing.new) }
    it { should_not be_able_to(:manage, TypeOfRelationship.new) }
    it { should_not be_able_to(:read, Country.new) }
    it { should_not be_able_to(:read, DeregisteredReason.new) }
    it { should_not be_able_to(:read, Gender.new) }
    it { should_not be_able_to(:read, Language.new) }
    it { should_not be_able_to(:read, LegalCode.new) }
    it { should_not be_able_to(:read, MovedOutReason.new) }
    it { should_not be_able_to(:read, Municipality.new) }
    it { should_not be_able_to(:read, OwnerType.new) }
    it { should_not be_able_to(:read, Setting.new) }
    it { should_not be_able_to(:read, Ssn.new) }
    it { should_not be_able_to(:read, TargetGroup.new) }
    it { should_not be_able_to(:read, TypeOfHousing.new) }
    it { should_not be_able_to(:read, TypeOfRelationship.new) }
    it { should_not be_able_to(:read, ExtraContributionType.new) }

    it { should be_able_to(:read, Cost.new) }
    it { should be_able_to(:read, ExtraContribution.new) }
    it { should be_able_to(:read, FamilyAndEmergencyHomeCost.new) }
    it { should be_able_to(:read, Home.new) }
    it { should be_able_to(:read, Placement.new) }
    it { should be_able_to(:read, Refugee.new) }
    it { should be_able_to(:read, Relationship.new) }
    it { should be_able_to(:read, User.new) }

    it { should be_able_to(:view, :statistics) }

    it { should be_able_to(%i[edit update drafts], drafted_refugee) }
    it { should be_able_to(%i[read create edit update], build(:dossier_number, refugee: drafted_refugee)) }
    it { should be_able_to(%i[read create edit update], drafted_placement) }
    it { should be_able_to(%i[read create edit update], build(:placement_extra_cost, placement: drafted_placement)) }
    it { should be_able_to(%i[read create edit update], build(:family_and_emergency_home_cost, placement: drafted_placement)) }
    it { should be_able_to(%i[read create edit update], build(:extra_contribution, refugee: drafted_refugee)) }
    it { should be_able_to(%i[read create edit update], build(:refugee_extra_cost, refugee: drafted_refugee)) }
    it { should be_able_to(%i[read create edit update], build(:relationship, refugee_id: drafted_refugee.id)) }
    it { should be_able_to(%i[read create edit update], build(:ssn, refugee_id: drafted_refugee.id)) }

    it { should_not be_able_to(:generate, :reports) }
  end
end
