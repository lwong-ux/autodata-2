class Request < ApplicationRecord
  belongs_to :cliente
  belongs_to :part
  belongs_to :incident_type
end
