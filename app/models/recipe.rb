class Recipe < ApplicationRecord
  include PgSearch::Model

  belongs_to :user
  has_many :spoons, class_name: "Recipe",
           foreign_key: "original_id"
  has_and_belongs_to_many :cookbooks
  belongs_to :original, class_name: "Recipe", optional: true
  has_one_attached :image, dependent: :destroy
  has_many :ingredients, dependent: :destroy
  has_many :instructions, dependent: :destroy

  acts_as_taggable_on :tags

  accepts_nested_attributes_for :ingredients, allow_destroy: true
  accepts_nested_attributes_for :instructions, allow_destroy: true

  multisearchable against: [:title, :description, :ingredients_to_s, :instructions_to_s]

  private

  def ingredients_to_s
    ingredients.map(&:body).join(' ')
  end

  def instructions_to_s
    instructions.map(&:body).join(' ')
  end

end
