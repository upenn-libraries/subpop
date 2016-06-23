class Ability
  include CanCan::Ability

  # We have three kinds of users: (1) the public, not logged in;
  # (2) a logged in user; (3) an admin
  def initialize(user)
    user ||= User.new
    # the public can read most things (not users)
    can :read, Book
    can :read, Evidence
    can :read, Name
    can :read, TitlePage

    return if user.new_record?

    # admins can manage anything
    if user.admin?
      can :manage, :all
      return
    end

    # user must be logged in allow full management (not users)
    can :manage, Book
    can :manage, Evidence
    can :manage, TitlePage
    can :manage, ProvenanceAgent
    can :manage, Name
    can :manage, Photo
    can :manage, :flickr
  end
end