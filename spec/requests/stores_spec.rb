require 'rails_helper'

RSpec.describe "Stores", type: :request do
  it 'displays empty message when there are no stores' do
    get stores_path
    expect(response.body).to include('No data to display')
  end

  it 'displays stores and transactions' do
    store = Store.create!(name: 'Test Store', owner: 'John Doe')
    Transaction.create!(store: store, transaction_type: 1, date: Date.today, amount: 100.0, cpf: '12345678901', card: '1234****5678', time: Time.now, description: 'Debit', nature: 'Income')
    get stores_path
    expect(response.body).to include('Test Store')
    expect(response.body).to include('Debit')
  end
end
