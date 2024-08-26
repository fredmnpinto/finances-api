class CreateExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :expenses do |t|
      t.text :title, null: false
      t.float :amount, precision: 5, scale: 2, null: false
      t.integer :currency, null: false

      t.timestamps
    end
  end
end
