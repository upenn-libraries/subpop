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

    # user must be logged in allow full management
    # allow user to manage all child objects of own books
    can :manage, Book,      created_by_id: user.id
    can :manage, Evidence,  book: { created_by_id: user.id }
    can :manage, TitlePage, book: { created_by_id: user.id }
    can :manage, Photo,     book: { created_by_id: user.id }
    can :manage, Name
    can :manage, :flickr
  end
end