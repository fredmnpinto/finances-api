class AddGroupReferenceToExpenses < ActiveRecord::Migration[7.1]
  def change
    add_reference :expenses, :group, foreign_key: true, null: false
  end
end
