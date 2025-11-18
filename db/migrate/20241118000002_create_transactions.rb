class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.references :store, null: false, foreign_key: true
      t.integer :transaction_type, null: false
      t.date :date, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :cpf, null: false, limit: 11
      t.string :card, null: false, limit: 12
      t.time :time, null: false
      t.string :nature, null: false
      t.string :description, null: false

      t.timestamps
    end

    add_index :transactions, :date
    add_index :transactions, :transaction_type
  end
end
