require 'rails_helper'

RSpec.describe Expense, type: :model do
  it { should validate_presence_of :amount }
  it { should validate_presence_of :currency }

  it { should belong_to :group }
end
