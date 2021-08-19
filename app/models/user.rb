class User < ApplicationRecord
  belongs_to :cliente

  #validates :nombre, presence: true
  #validates :p_apellido, presence: true
  #validates :usuario, presence: true
end
