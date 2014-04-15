class Ability
  include CanCan::Ability

  def initialize(user)

    # public resources, so no need to define abilities
    # can :read, WordSet
    # can :read, Word
    # can :read, Definition

    if user
      can :manage, :all
    end

  end
end
