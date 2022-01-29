class Cookbook < ApplicationRecord
  include PgSearch::Model

  belongs_to :user
  has_and_belongs_to_many :recipes
  has_one_attached :image

  multisearchable against: [:title, :description]

  def add_or_remove_recipe(recipe)
    recipes.exists?(recipe.id) ? recipes.delete(recipe) : recipes << recipe
    save!
  end
end
