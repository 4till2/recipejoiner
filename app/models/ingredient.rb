class Ingredient < ApplicationRecord
  belongs_to :recipe, touch: true
end
