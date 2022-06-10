class Prefecture < ApplicationRecord
  has_many :actresses

  validates :name, presence: true
  validates :forecast, presence: true
end
