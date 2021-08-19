class Quotation < ApplicationRecord
  belongs_to :cliente
  belongs_to :request
end
