class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin
      can :manage, :all
      can :destroy, Refugee
      cannot :destroy, Home
      cannot :create, RateCategory
      cannot :destroy, RateCategory
      cannot :manage, Rate
      cannot [:edit, :update], PaymentImport
      cannot [:edit, :update], Payment

    elsif user.has_role? :writer
      can :manage, Refugee
      cannot :destroy, Refugee
      can :manage, ExtraContribution
      can :manage, RefugeeExtraCost
      can :read, Home
      can :read, User
      can :manage, Relationship
      can :manage, Placement
      cannot :destroy, Placement
      can :manage, FamilyAndEmergencyHomeCost
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
      can :manage, Placement, refugee: { draft: true }
      can :manage, FamilyAndEmergencyHomeCost, placement: { refugee: { draft: true } }
      can :manage, ExtraContribution, refugee: { draft: true }
      can :manage, RefugeeExtraCost, refugee: { draft: true }
      cannot :destroy, Placement
      cannot :destroy, FamilyAndEmergencyHomeCost
      cannot :destroy, ExtraContribution
      cannot :destroy, RefugeeExtraCost

      # Model-less controllers
      can :view, :statistics
    end

    if user.has_role?(:super_reader)
      can :generate, :reports
    end
  end
end
