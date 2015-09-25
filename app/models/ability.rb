class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, :all if user.admin?
    can :create, :all if user
    can :read, :all
  end
end
