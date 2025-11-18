require 'rails_helper'

describe Store, type: :model do
  it 'é inválido sem nome' do
    store = Store.new(owner: 'Fulano')
    expect(store).not_to be_valid
  end

  it 'é inválido sem owner' do
    store = Store.new(name: 'Loja 1')
    expect(store).not_to be_valid
  end

  it 'é válido com nome e owner' do
    store = Store.new(name: 'Loja 1', owner: 'Fulano')
    expect(store).to be_valid
  end
end
