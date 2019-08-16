RSpec.describe User, type: :ability do
  describe 'with writer role' do
    subject(:ability) { Ability.new(user) }

    let(:user) { build(:user, role: 'writer') }

    it { should be_able_to(:manage, DossierNumber.new) }
    it { should be_able_to(:manage, ExtraContribution.new) }
    it { should be_able_to(%i[read create edit update], FamilyAndEmergencyHomeCost.new) }
    it { should be_able_to(%i[read create edit update], Placement.new) }
    it { should be_able_to(%i[read create edit update], PlacementExtraCost.new) }
    it { should be_able_to(%i[read search suggest create edit update], Person.new) }
    it { should be_able_to(:manage, PersonExtraCost.new) }
    it { should be_able_to(:manage, Relationship.new) }
    it { should be_able_to(:manage, Ssn.new) }
    it { should be_able_to(:generate, :reports) }
    it { should be_able_to(:view, :statistics) }

    it { should_not be_able_to(:manage, Cost.new) }
    it { should_not be_able_to(:manage, Country.new) }
    it { should_not be_able_to(:manage, DeregisteredReason.new) }
    it { should_not be_able_to(:manage, ExtraContributionType.new) }
    it { should_not be_able_to(:manage, Gender.new) }
    it { should_not be_able_to(:manage, Home.new) }
    it { should_not be_able_to(:manage, Language.new) }
    it { should_not be_able_to(:manage, LegalCode.new) }
    it { should_not be_able_to(:manage, MovedOutReason.new) }
    it { should_not be_able_to(:manage, Municipality.new) }
    it { should_not be_able_to(:manage, OwnerType.new) }
    it { should_not be_able_to(:manage, Payment.new) }
    it { should_not be_able_to(:manage, PaymentImport.new) }
    it { should_not be_able_to(:manage, PoRate.new) }
    it { should_not be_able_to(:manage, OneTimePayment.new) }
    it { should_not be_able_to(:manage, Rate.new) }
    it { should_not be_able_to(:manage, RateCategory.new) }
    it { should_not be_able_to(:manage, Setting.new) }
    it { should_not be_able_to(:manage, TargetGroup.new) }
    it { should_not be_able_to(:manage, TypeOfHousing.new) }
    it { should_not be_able_to(:manage, TypeOfRelationship.new) }
    it { should_not be_able_to(:manage, User.new) }

    it { should_not be_able_to(:read, Country.new) }
    it { should_not be_able_to(:read, DeregisteredReason.new) }
    it { should_not be_able_to(:read, ExtraContributionType.new) }
    it { should_not be_able_to(:read, ExtraContributionType.new) }
    it { should_not be_able_to(:read, Gender.new) }
    it { should be_able_to(:read, Home.new) }
    it { should_not be_able_to(:read, Language.new) }
    it { should_not be_able_to(:read, LegalCode.new) }
    it { should_not be_able_to(:read, MovedOutReason.new) }
    it { should_not be_able_to(:read, Municipality.new) }
    it { should_not be_able_to(:read, OwnerType.new) }
    it { should_not be_able_to(:read, Payment.new) }
    it { should_not be_able_to(:read, PaymentImport.new) }
    it { should_not be_able_to(:read, PoRate.new) }
    it { should_not be_able_to(:read, OneTimePayment.new) }
    it { should_not be_able_to(:read, TargetGroup.new) }
    it { should_not be_able_to(:read, TypeOfHousing.new) }
    it { should_not be_able_to(:read, TypeOfRelationship.new) }

    it { should be_able_to(:read, User.new) }
  end
end
