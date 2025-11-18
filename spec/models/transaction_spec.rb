require 'rails_helper'

describe Transaction, type: :model do
  let(:store) { Store.create!(name: 'Loja 1', owner: 'Fulano') }

  it 'é inválido sem valor' do
    t = Transaction.new(store: store)
    expect(t).not_to be_valid
  end

  it 'é válido com todos os campos obrigatórios' do
    t = Transaction.new(
      store: store,
      transaction_type: 1,
      date: Date.today,
      amount: 100.0,
      cpf: '12345678901',
      card: '1234****5678',
      time: Time.now,
      description: 'Débito',
      nature: 'Entrada'
    )
    expect(t).to be_valid
  end
end
