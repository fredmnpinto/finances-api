class CreateGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :groups do |t|
      t.text :name
      t.text :external_identifier

      t.timestamps
    end
    add_index :groups, :external_identifier, unique: true
  end
end
