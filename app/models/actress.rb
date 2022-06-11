class Actress < ApplicationRecord
  validates :name, presence: true
  validates :cup, presence: true
  validates :prefecture, presence: true
  validates :image, presence: true
  validates :digital, presence: true
end
