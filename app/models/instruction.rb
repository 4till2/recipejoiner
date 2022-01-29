class Instruction < ApplicationRecord
  belongs_to :recipe, touch: true
  has_one_attached :image
end
