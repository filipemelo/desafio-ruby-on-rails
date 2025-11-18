class Store < ApplicationRecord
  has_many :transactions, dependent: :destroy

  validates :name, presence: true
  validates :owner, presence: true

  # Calcula o saldo total da loja
  def balance
    transactions.sum do |transaction|
      transaction.entrada? ? transaction.amount : -transaction.amount
    end
  end
end
