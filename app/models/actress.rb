class Actress < ApplicationRecord
  belongs_to :prefecture

  validates :name, presence: true
  validates :cup, presence: true
  validates :prefecture, presence: true
  validates :image, presence: true
  validates :digital, presence: true
end
