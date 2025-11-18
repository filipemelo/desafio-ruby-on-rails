
require 'rails_helper'

RSpec.describe CnabImporter, type: :service do
  # CNAB line with correctly aligned fields (81 characters)
  # Type(1) Date(8) Amount(10) CPF(11) Card(12) Time(6) Owner(14) Store(19)
  # Owner: 'JOAO MACEDO   ' (14 chars), Store: 'BAR DO JOAO         ' (19 chars)
  let(:file) { StringIO.new("1201903010000014200096206760174753****3153153453JOAO MACEDO   BAR DO JOAO         ") }

  it 'imports a transaction and store correctly' do
    result = CnabImporter.import(file)
    expect(result[:success]).to eq(true)
    expect(Store.count).to eq(1)
    expect(Transaction.count).to eq(1)
    expect(Store.first.name).to eq('BAR DO JOAO')
  end

  it 'returns error for invalid line' do
    file = StringIO.new("linha_invalida")
    result = CnabImporter.import(file)
    expect(result[:success]).to eq(false)
    expect(result[:errors]).not_to be_empty
  end
end
