require 'rails_helper'

RSpec.describe StoresController, type: :controller do
  render_views

  it 'exibe mensagem de vazio quando não há lojas' do
    get :index
    expect(response.body).to include('Não há dados para exibir')
  end

  it 'exibe lojas quando existem' do
    Store.create!(name: 'Loja Teste', owner: 'Fulano')
    get :index
    expect(response.body).to include('Loja Teste')
  end
end
