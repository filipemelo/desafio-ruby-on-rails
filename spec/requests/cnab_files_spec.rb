require 'rails_helper'

RSpec.describe "CnabFiles", type: :request do
  it 'renderiza o formulário de upload' do
    get new_cnab_file_path
    expect(response).to be_successful
    expect(response.body).to include('Upload de Arquivo CNAB')
  end

  it 'faz upload inválido e mostra erro' do
    post cnab_files_path, params: { cnab_file: { file: nil } }
    expect(response.body).to include('Upload de Arquivo CNAB')
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it 'faz upload válido e redireciona para stores' do
    file = fixture_file_upload(Rails.root.join('spec/fixtures/files/cnab.txt'), 'text/plain')
    post cnab_files_path, params: { cnab_file: { file: file } }
    expect(response).to redirect_to(stores_path)
    follow_redirect!
    expect(response.body).to include('Lojas e Transações')
  end
end
