class CreateStores < ActiveRecord::Migration[8.1]
  def change
    create_table :stores do |t|
      t.string :name, null: false
      t.string :owner, null: false

      t.timestamps
    end

    add_index :stores, :name
  end
end
