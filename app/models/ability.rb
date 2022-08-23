# frozen_string_literal: true

# The ability class generates authorization for several roles, each of which will have its own set of permissions.

class Ability
  include CanCan::Ability

  def initialize(user)

    if user.present? # Check whether a user is logged in or not

      if user.role.name == "admin"
        can :manage, :all
      end

      if user.role.name == "student"
        can %i[read], Book
      end

    end
  end
end
