class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin
      can :manage, :all

    elsif user.has_role? :writer
      can :manage, Refugee
      can :manage, Home
      can :read, User
      can :generate, :reports
      can :view, :statistics

    elsif user.has_role? :reader
      can :read, Home
      can [:read, :search, :suggest], Refugee
      can :read, User

      # 'reader' create, and edit and list refugee drafts
      can :create, Refugee
      can [:edit, :update, :drafts], Refugee, draft: true

       # Model less controllers
      can :generate, :reports
      can :view, :statistics
    end
  end
end
