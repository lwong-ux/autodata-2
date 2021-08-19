class Part < ApplicationRecord
  belongs_to :plant

  validates :num_parte, presence: true
  validates :nombre, presence: true, length: { minimum: 4 }
end
