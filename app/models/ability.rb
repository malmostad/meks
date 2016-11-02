class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin
      can :manage, :all
      cannot :destroy, Home
      cannot :destroy, Refugee

    elsif user.has_role? :writer
      can :manage, Refugee
      can :manage, Home
      cannot :destroy, Home
      cannot :destroy, Refugee
      can :manage, User
      can :manage, Relationship
      can :manage, Placement
      can :generate, :reports
      can :view, :statistics

    elsif user.has_role?(:reader) || user.has_role?(:super_reader)
      can :read, Home
      can [:read, :search, :suggest], Refugee
      can :read, User
      can :read, Relationship
      can :read, Placement

      # 'reader' create, and edit and list refugee drafts
      can :create, Refugee
      can [:edit, :update, :drafts], Refugee, draft: true
      can :manage, Relationship, refugee: { draft: true }
      can :manage, Placement, refugee: { draft: true }

      # Model-less controllers
      can :view, :statistics
    end

    if user.has_role?(:super_reader)
      can :generate, :reports
    end
  end
end
