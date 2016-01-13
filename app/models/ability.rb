class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :writer
      can :manage, :all
    elsif user.has_role? :reader
      can :read, Refugee
      can :read, Home
      can [:read, :search, :suggest], Refugee
      can :generate, :reports

      alias_action :create, :update, :edit, :drafts, to: :draft
      can :draft, Refugee, draft: true
    end
  end
end
