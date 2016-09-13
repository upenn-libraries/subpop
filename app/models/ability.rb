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

    # Have photo abilities depend on associated objects.
    #
    # https://github.com/CanCanCommunity/cancancan/wiki/Share-Ability-Definitions
    can :manage, Photo do |photo|
      case
      when photo.book.present?
        can? :manage, photo.book
      when photo.evidence.present?
        can? :manage, photo.evidence.first
      when photo.title_pages.present?
        can? :manage, photo.title_pages.first
      when photo.context_images.present?
        can? :manage, context_images.first
      end
    end

    can :manage, Name,      created_by_id: user.id
  end
end