class Expense < ApplicationRecord
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :title, presence: true
  validates :currency, presence: true
  enum :currency, %i[USD GBP EUR BRL].freeze, scopes: false
end
