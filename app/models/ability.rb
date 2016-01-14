class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :writer
      can :manage, :all
    elsif user.has_role? :reader
      can :read, Home
      can [:read, :search, :suggest], Refugee

      # 'reader' can edit and list refugee drafts
      can [:edit, :create, :update, :drafts], Refugee, draft: true

       # Model less controller
      can :generate, :reports
    end
  end
end
