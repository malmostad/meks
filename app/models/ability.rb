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
      can %i[read show_placements show_costs show_economy show_relateds search suggest create edit update], Person
      can :manage, PersonExtraCost
      can :manage, Relationship
      can :manage, Ssn
      can :read, Cost
      can :read, Home
      can :read, User
      can :generate, :reports
      can :view, :statistics

    elsif user.has_role?(:reader) || user.has_role?(:super_reader)
      can %i[read create edit update], DossierNumber, person: { draft: true }
      can %i[read create edit update], ExtraContribution, person: { draft: true }
      can %i[read create edit update], FamilyAndEmergencyHomeCost, placement: { person: { draft: true } }
      can %i[read create edit update], Placement, person: { draft: true }
      can %i[read create edit update], PlacementExtraCost, placement: { person: { draft: true } }
      can :create, Person
      can %i[edit update drafts], Person, draft: true
      can %i[read create edit update], PersonExtraCost, person: { draft: true }
      can %i[read create edit update], Relationship, person: { draft: true }
      can %i[read create edit update], Ssn, person: { draft: true }

      can :read, Cost
      can :read, DossierNumber
      can :read, ExtraContribution
      can :read, FamilyAndEmergencyHomeCost
      can :read, Home
      can :read, Placement
      can :read, PlacementExtraCost
      can %i[read show_placements show_costs show_economy show_relateds search suggest], Person
      can :read, PersonExtraCost
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
