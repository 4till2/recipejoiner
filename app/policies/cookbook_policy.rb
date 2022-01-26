class CookbookPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def add_or_remove_recipe?
    owner?
  end

end