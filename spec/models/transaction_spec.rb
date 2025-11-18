require 'rails_helper'

describe Transaction, type: :model do
  let(:store) { Store.create!(name: 'Store 1', owner: 'John Doe') }

  it 'is invalid without amount' do
    t = Transaction.new(store: store)
    expect(t).not_to be_valid
  end

  it 'is valid with all required fields' do
    t = Transaction.new(
      store: store,
      transaction_type: 1,
      date: Date.today,
      amount: 100.0,
      cpf: '12345678901',
      card: '1234****5678',
      time: Time.now,
      description: 'Debit',
      nature: 'Income'
    )
    expect(t).to be_valid
  end
end
