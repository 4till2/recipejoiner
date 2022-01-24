# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  # Handled by authorization
  def index?
    false
  end

  def show?
    owner? || public? || subscriber?
  end

  # Handled by authorization
  def create?
    false
  end

  def new?
    create?
  end

  def update?
    owner?
  end

  def edit?
    update?
  end

  def destroy?
    owner?
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end

    private

    attr_reader :user, :scope

  end

  private

  def public?
    false
  end

  def owner?
    @record.user_id == @user.id
  end
end
