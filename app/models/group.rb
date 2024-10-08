class Group < ApplicationRecord
  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups
  has_many :expenses, dependent: :destroy

  validates :name, presence: true
end
