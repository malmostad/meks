RSpec.describe User, type: :ability do
  describe 'with admin role' do
    subject(:ability) { Ability.new(user) }

    let(:user) { build(:user, role: 'admin') }
    let(:payment_import) { create(:payment_import) }
    let(:payment) { create(:payment) }

    it { should be_able_to(:manage, Cost.new) }
    it { should be_able_to(:manage, Country.new) }
    it { should be_able_to(:manage, DeregisteredReason.new) }
    it { should be_able_to(:manage, DossierNumber.new) }
    it { should be_able_to(:manage, ExtraContribution.new) }
    it { should be_able_to(:manage, ExtraContributionType.new) }
    it { should be_able_to(:manage, FamilyAndEmergencyHomeCost.new) }
    it { should be_able_to(:manage, Gender.new) }
    it { should be_able_to(:manage, Home.new) }
    it { should_not be_able_to(:destroy, Home.new) }
    it { should be_able_to(:manage, Language.new) }
    it { should_not be_able_to(:manage, LegalCode.new) }
    it { should be_able_to(:manage, MovedOutReason.new) }
    it { should be_able_to(:manage, Municipality.new) }
    it { should be_able_to(:manage, OwnerType.new) }
    it { should be_able_to(:manage, Placement.new) }
    it { should be_able_to(:manage, PlacementExtraCost.new) }
    it { should be_able_to(:manage, PoRate.new) }
    it { should be_able_to(:manage, OneTimePayment.new) }
    it { should be_able_to(:manage, Rate.new) }
    it { should_not be_able_to(:create, RateCategory.new) }
    it { should_not be_able_to(:destroy, RateCategory.new) }
    it { should be_able_to(:manage, Person.new) }
    it { should be_able_to(:manage, PersonExtraCost.new) }
    it { should be_able_to(:manage, Relationship.new) }
    it { should be_able_to(:manage, Ssn.new) }
    it { should be_able_to(:manage, TargetGroup.new) }
    it { should_not be_able_to(:manage, TypeOfHousing.new) }
    it { should be_able_to(:manage, TypeOfRelationship.new) }
    it { should_not be_able_to(:manage, User.new) }

    it { should be_able_to(:edit, Setting.new) }
    it { should_not be_able_to(:create, Setting.new) }
    it { should_not be_able_to(:destroy, Setting.new) }

    it { should be_able_to(:read, Country.new) }
    it { should be_able_to(:read, DeregisteredReason.new) }
    it { should be_able_to(:read, ExtraContribution.new) }
    it { should be_able_to(:read, ExtraContributionType.new) }
    it { should be_able_to(:read, FamilyAndEmergencyHomeCost.new) }
    it { should be_able_to(:read, Gender.new) }
    it { should be_able_to(:read, Home.new) }
    it { should be_able_to(:read, Language.new) }
    it { should_not be_able_to(:read, LegalCode.new) }
    it { should be_able_to(:read, MovedOutReason.new) }
    it { should be_able_to(:read, Municipality.new) }
    it { should be_able_to(:read, OwnerType.new) }
    it { should be_able_to(:read, Placement.new) }
    it { should be_able_to(:read, RateCategory.new) }
    it { should be_able_to(:read, Person.new) }
    it { should be_able_to(:read, PersonExtraCost.new) }
    it { should be_able_to(:read, Relationship.new) }
    it { should be_able_to(:read, Ssn.new) }
    it { should be_able_to(:read, TargetGroup.new) }
    it { should_not be_able_to(:read, TypeOfHousing.new) }
    it { should be_able_to(:read, TypeOfRelationship.new) }
    it { should be_able_to(:read, User.new) }
    it { should be_able_to(:view, :statistics) }

    it { should be_able_to(:generate, :reports) }

    it { should be_able_to(:create, :payment_imports) }
    it { should be_able_to(:read, :payment_imports) }
    it { should be_able_to(:destroy, :payment_imports) }

    it { should_not be_able_to(:edit, payment_import) }
    it { should_not be_able_to(:update, payment_import) }
    it { should_not be_able_to(:edit, payment) }
    it { should_not be_able_to(:update, payment) }
  end
end
