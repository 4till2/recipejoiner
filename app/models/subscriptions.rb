class Subscriptions < ApplicationRecord
  belongs_to :subscribable, polymorphic: true
  belongs_to :subscriber, class_name: 'User'

  # validates_comparison_of :subscriber, other_than: :owner, message: 'mustn\'t subscribe to thy own self'

  def owner
    return subscribable if subscribable_type == 'User'

    subscribable.user
  end

  def recipes
    subscribable.recipes.order(created_at: :desc)
  end
end
