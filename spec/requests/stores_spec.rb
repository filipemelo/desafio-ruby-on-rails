require 'rails_helper'

RSpec.describe "Stores", type: :request do
  it 'exibe mensagem de vazio quando não há lojas' do
    get stores_path
    expect(response.body).to include('Não há dados para exibir')
  end

  it 'exibe lojas e transações' do
    store = Store.create!(name: 'Loja Teste', owner: 'Fulano')
    Transaction.create!(store: store, transaction_type: 1, date: Date.today, amount: 100.0, cpf: '12345678901', card: '1234****5678', time: Time.now, description: 'Débito', nature: 'Entrada')
    get stores_path
    expect(response.body).to include('Loja Teste')
    expect(response.body).to include('Débito')
  end
end
