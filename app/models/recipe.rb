class Recipe < ApplicationRecord
  belongs_to :user
  has_many :spoons, class_name: "Recipe",
           foreign_key: "original_id"

  belongs_to :original, class_name: "Recipe", optional: true
  has_one_attached :image, dependent: :destroy
  has_many :ingredients, dependent: :destroy
  has_many :instructions, dependent: :destroy
  acts_as_taggable_on :tags
  accepts_nested_attributes_for :ingredients, allow_destroy: true
  accepts_nested_attributes_for :instructions, allow_destroy: true
end
