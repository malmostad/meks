RSpec.describe User, type: :ability do
  describe 'with super_writer role' do
    subject(:ability) { Ability.new(user) }

    let(:user) { build(:user, role: 'super_reader') }
    let(:person) { create(:person) }
    let(:drafted_person) { create(:person, draft: true) }
    let(:drafted_placement) { create(:placement, person: drafted_person) }

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
    it { should_not be_able_to(:manage, PoRate.new) }
    it { should_not be_able_to(:manage, OneTimePayment.new) }
    it { should_not be_able_to(:manage, Rate.new) }
    it { should_not be_able_to(:manage, RateCategory.new) }
    it { should_not be_able_to(:manage, Person.new) }
    it { should_not be_able_to(:manage, PersonExtraCost.new) }
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
    it { should_not be_able_to(:read, PoRate.new) }
    it { should_not be_able_to(:read, OneTimePayment.new) }
    it { should_not be_able_to(:read, Setting.new) }
    it { should_not be_able_to(:read, TargetGroup.new) }
    it { should_not be_able_to(:read, TypeOfHousing.new) }
    it { should_not be_able_to(:read, TypeOfRelationship.new) }
    it { should_not be_able_to(:read, ExtraContributionType.new) }

    it { should be_able_to(:read, Cost.new) }
    it { should be_able_to(:read, ExtraContribution.new) }
    it { should be_able_to(:read, FamilyAndEmergencyHomeCost.new) }
    it { should be_able_to(:read, Home.new) }
    it { should be_able_to(:read, Placement.new) }
    it { should be_able_to(%i[read search suggest], Person.new) }
    it { should be_able_to(:read, Relationship.new) }
    it { should be_able_to(:read, Ssn.new) }
    it { should be_able_to(:read, User.new) }

    it { should be_able_to(:view, :statistics) }

    it { should be_able_to(%i[edit update drafts], drafted_person) }
    it { should be_able_to(%i[read create edit update], build(:dossier_number, person: drafted_person)) }
    it { should be_able_to(%i[read create edit update], drafted_placement) }
    it { should be_able_to(%i[read create edit update], build(:placement_extra_cost, placement: drafted_placement)) }
    it { should be_able_to(%i[read create edit update], build(:family_and_emergency_home_cost, placement: drafted_placement)) }
    it { should be_able_to(%i[read create edit update], build(:extra_contribution, person: drafted_person)) }
    it { should be_able_to(%i[read create edit update], build(:person_extra_cost, person: drafted_person)) }
    it { should be_able_to(%i[read create edit update], build(:relationship, person_id: drafted_person.id)) }
    it { should be_able_to(%i[read create edit update], build(:ssn, person_id: drafted_person.id)) }

    it { should be_able_to(:generate, :reports) }
  end
end
