class User < ApplicationRecord
  include PgSearch::Model

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :username,
            uniqueness: {
              # object = person object being validated
              # data = { model: "User", attribute: "Username", value: <username> }
              message: ->(object, data) do
                "#{object.name}, #{data[:value]} is already taken."
              end
            }
  validates :username, presence: { message: "must be given please." }
  validates :username, length: { minimum: 4, maximum: 12, message: 'must be between 4 and 12 characters.' }
  validates :username, format: { with: /\A\w+\Z/, message: "can only contain letters, numbers and underscores." }
  validates :full_name, presence: { message: "must be given please." }


  has_many :subscribees, as: :subscribable, class_name: 'Subscriptions'
  has_many :subscriptions, foreign_key: 'subscriber_id', dependent: :destroy, class_name: 'Subscriptions'
  has_many :subscribers, through: :subscribees
  has_many :recipes, dependent: :destroy, class_name: 'Recipe'
  has_many :cookbooks, dependent: :destroy

  has_many :cookbook_subscriptions, -> { readonly }, through: :subscriptions, source: :subscribable, source_type: 'Cookbook'
  has_many :user_subscriptions, -> { readonly }, through: :subscriptions, source: :subscribable, source_type: 'User'

  has_many :recipes_from_cookbooks, -> { readonly }, through: :cookbooks, source: :recipes
  has_many :recipes_from_cookbook_subscriptions, -> { readonly }, through: :cookbook_subscriptions, source: :recipes
  has_many :recipes_from_user_subscriptions, -> { readonly }, through: :user_subscriptions, source: :recipes

  has_one_attached :avatar, dependent: :destroy

  multisearchable against: [:username]

  DEFAULT_FEED_COUNT = 10

  def paginated_collection(src)
    case src
    when 'owned_recipes'
      recipes
    when 'saved_recipes'
      saved_recipes
    when 'owned_cookbooks'
      cookbooks
    when 'saved_cookbooks'
      cookbook_subscriptions
    when 'cookbook_subscriptions'
      recipes_from_cookbook_subscriptions
    when 'user_subscriptions'
      recipes_from_user_subscriptions
    end
  end

  def subscribe_or_unsubscribe(subscribable_id, subscribable_type)
    if subscriptions.exists?(subscribable_id: subscribable_id, subscribable_type: subscribable_type)
      subscriptions.find_by(subscribable_id: subscribable_id, subscribable_type: subscribable_type).destroy
      false
    else
      subscriptions.create!(subscribable_id: subscribable_id,
                            subscribable_type: subscribable_type)
      true
    end
  end

  def saved_recipes
    recipes_from_cookbooks.where.not(user_id: id)
  end

  def recent_subscriptions(total = DEFAULT_FEED_COUNT)
    return if total.negative?

    l = total / 2
    (cookbook_subscriptions.last(l) + user_subscriptions.last(l)).sort_by(&:created_at)
  end

  def discover_recipes(total = DEFAULT_FEED_COUNT)
    return if total.negative?

    l = total / 6
    list =
      (recipes.last(l) +
        saved_recipes.last(l) +
        recipes_from_cookbook_subscriptions.last(l) +
        recipes_from_user_subscriptions.last(l) +
        recipes_from_cookbooks.last(l) +
        Recipe.where.not(user_id: id).last(l)
      ).shuffle

    # Load with suggestions when user is not active
    pad_with_suggestions(list, l, total, 'Recipe')
  end

  def discover_cookbooks(total = DEFAULT_FEED_COUNT)
    return if total.negative?

    l = total / 3

    list =
      (cookbooks.last(l) +
        cookbook_subscriptions.last(l) +
        Cookbook.where.not(user_id: id).last(l)
      ).shuffle

    # Load with suggestions when user is not active
    pad_with_suggestions(list, l, total, 'Cookbook')
  end

  def discover_users(total = DEFAULT_FEED_COUNT)
    return if total.negative?

    l = total / 3

    list =
      (user_subscriptions.last(l) +
        # owners of cookbook subscriptions
        cookbook_subscriptions.includes(:user).last(l).map(&:user).flatten +
        User.where.not(id: id).last(l)
      ).shuffle

    # Load with suggestions when user is not active
    pad_with_suggestions(list, l, total, 'User')
  end

  def discover_recommendations(total = DEFAULT_FEED_COUNT)
    return if total.negative?

    l = total / 3
    (Recipe.where.not(user_id: id).last(l) +
      Cookbook.where.not(user_id: id).last(l) +
      User.where.not(id: id).last(l)
    ).shuffle

  end

  def as_chef
    User.chef.find(id)
  end

  def self.all_chefs
    all.chef
  end

  private

  def self.chef
    includes(:recipes, :cookbooks).select(:full_name, :username, :recipes, :cookbooks).references(:recipes, :cookbooks)
  end

  def pad_with_suggestions(list, amount, total, klass)
    list ||= []
    offset = 0
    while list.count < total - amount && offset <= 100
      offset += amount
      list += klass.constantize.offset(offset).last(amount)
    end
    list
  end

end
