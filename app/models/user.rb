class User < ApplicationRecord
  include PgSearch::Model

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :subscribees, as: :subscribable, class_name: 'Subscriptions'
  has_many :subscriptions, foreign_key: 'subscriber_id', dependent: :destroy, class_name: 'Subscriptions'
  has_many :subscribers, through: :subscribees
  has_many :recipes, dependent: :destroy, class_name: 'Recipe'
  has_many :cookbooks, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy

  multisearchable against: [:username]

  def feed
    subscriptions.includes(:subscribable).map(&:recipes).flatten.uniq
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

  def as_chef
    User.chef.find(id)
  end

  def self.all_chefs
    all.chef
  end

  private

  def self.chef
    includes(:recipes, :cookbooks).select(:username, :recipes, :cookbooks).references(:recipes, :cookbooks)
  end

end
