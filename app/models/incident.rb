class Incident < ApplicationRecord
  belongs_to :inspection
  belongs_to :incident_type
end
