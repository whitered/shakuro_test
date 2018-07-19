class Supply < ApplicationRecord
  belongs_to :book
  belongs_to :shop
end
