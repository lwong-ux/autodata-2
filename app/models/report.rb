class Report < ApplicationRecord
  belongs_to :user
  belongs_to :quotation
  has_many :inspections

  validates :quotation_id, presence: true
end
