class Instruction < ApplicationRecord
  belongs_to :recipe
  has_one_attached :image
end
