class Inspection < ApplicationRecord
  belongs_to :report
  has_many :incidents
end
