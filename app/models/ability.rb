class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin
      can :manage, :all
      cannot :manage, LegalCode
      cannot :manage, TypeOfHousing
      cannot :manage, User
      can :read, User
      cannot :destroy, Home
      cannot :create, RateCategory
      cannot :destroy, RateCategory
      cannot :create, Setting
      cannot :destroy, Setting
      cannot %i[edit update], PaymentImport
      cannot %i[edit update], Payment

    elsif user.has_role? :writer
      can :manage, DossierNumber
      can :manage, ExtraContribution
      can %i[read create edit update], FamilyAndEmergencyHomeCost
      can %i[read create edit update move_out move_out_update], Placement
      can %i[read create edit update], PlacementExtraCost
      can %i[read search suggest create edit update], Refugee
      can :manage, RefugeeExtraCost
      can :manage, Relationship
      can :manage, Ssn
      can :read, Cost
      can :read, Home
      can :read, User
      can :generate, :reports
      can :view, :statistics

    elsif user.has_role?(:reader) || user.has_role?(:super_reader)
      can %i[read create edit update], DossierNumber, refugee: { draft: true }
      can %i[read create edit update], ExtraContribution, refugee: { draft: true }
      can %i[read create edit update], FamilyAndEmergencyHomeCost, placement: { refugee: { draft: true } }
      can %i[read create edit update], Placement, refugee: { draft: true }
      can %i[read create edit update], PlacementExtraCost, placement: { refugee: { draft: true } }
      can :create, Refugee
      can %i[edit update drafts], Refugee, draft: true
      can %i[read create edit update], RefugeeExtraCost, refugee: { draft: true }
      can %i[read create edit update], Relationship, refugee: { draft: true }
      can %i[read create edit update], Ssn, refugee: { draft: true }

      can :read, Cost
      can :read, DossierNumber
      can :read, ExtraContribution
      can :read, FamilyAndEmergencyHomeCost
      can :read, Home
      can :read, Placement
      can :read, PlacementExtraCost
      can %i[read search suggest], Refugee
      can :read, RefugeeExtraCost
      can :read, Relationship
      can :read, Ssn
      can :read, User

      # Model-less controllers
      can :view, :statistics
    end

    if user.has_role?(:super_reader)
      can :generate, :reports
    end
  end
end
