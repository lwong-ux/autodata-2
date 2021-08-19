class Plant < ApplicationRecord
  validates :nombre, presence: true
  validates :contacto, presence: true, length: { minimum: 4 }
  validates :tel, presence: true, length: { minimum: 8 }
end
