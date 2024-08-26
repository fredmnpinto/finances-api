class User < ApplicationRecord
  has_many :user_groups
  has_many :groups, through: :user_groups, dependent: :destroy
  has_many :expenses, through: :groups

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
end
