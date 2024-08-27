class Expense < ApplicationRecord
  belongs_to :group, required: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :title, presence: true
  validates :currency, presence: true
  validates :group, presence: true

  enum :currency, %i[USD GBP EUR BRL].freeze, scopes: false
end
