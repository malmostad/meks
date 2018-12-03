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
      can %i[read create edit update], Placement
      can %i[read create edit update], PlacementExtraCost
      can %i[read create edit update], Refugee
      can :manage, RefugeeExtraCost
      can :manage, Relationship
      can :manage, Ssn
      can :read, Cost
      can :read, Home
      can :read, User
      can :generate, :reports
      can :view, :statistics

    elsif user.has_role?(:reader) || user.has_role?(:super_reader)
      can :read, Home
      can [:read, :search, :suggest], Refugee
      can :read, ExtraContribution
      can :read, RefugeeExtraCost
      can :read, User
      can :read, Relationship
      can :read, Placement
      can :read, FamilyAndEmergencyHomeCost

      # 'reader' create, and edit and list refugee drafts
      can :create, Refugee
      can [:edit, :update, :drafts], Refugee, draft: true
      can :manage, Relationship, refugee: { draft: true }
      cannot :destroy, DossierNumber
      can :manage, DossierNumber, refugee: { draft: true }
      cannot :destroy, Relationship
      can :manage, Placement, refugee: { draft: true }
      cannot :destroy, Placement
      can :manage, PlacementExtraCost, placement: { refugee: { draft: true } }
      cannot :destroy, PlacementExtraCost
      can :manage, FamilyAndEmergencyHomeCost, placement: { refugee: { draft: true } }
      cannot :destroy, FamilyAndEmergencyHomeCost
      can :manage, ExtraContribution, refugee: { draft: true }
      cannot :destroy, ExtraContribution
      can :manage, RefugeeExtraCost, refugee: { draft: true }
      cannot :destroy, RefugeeExtraCost

      # Model-less controllers
      can :view, :statistics
    end

    if user.has_role?(:super_reader)
      can :generate, :reports
    end
  end
end
