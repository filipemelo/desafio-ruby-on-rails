
require 'rails_helper'

RSpec.describe CnabImporter, type: :service do
  # Linha CNAB com campos corretamente alinhados (81 caracteres)
  # Tipo(1) Data(8) Valor(10) CPF(11) Cartão(12) Hora(6) Dono(14) Loja(19)
  # Dono: 'JOAO MACEDO   ' (14 chars), Loja: 'BAR DO JOAO         ' (19 chars)
  let(:file) { StringIO.new("1201903010000014200096206760174753****3153153453JOAO MACEDO   BAR DO JOAO         ") }

  it 'importa uma transação e loja corretamente' do
    result = CnabImporter.import(file)
    expect(result[:success]).to eq(true)
    expect(Store.count).to eq(1)
    expect(Transaction.count).to eq(1)
    expect(Store.first.name).to eq('BAR DO JOAO')
  end

  it 'retorna erro para linha inválida' do
    file = StringIO.new("linha_invalida")
    result = CnabImporter.import(file)
    expect(result[:success]).to eq(false)
    expect(result[:errors]).not_to be_empty
  end
end
