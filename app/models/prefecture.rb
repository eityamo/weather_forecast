class Prefecture < ApplicationRecord
  validates :name, presence: true
  validates :forecast, presence: true
end
