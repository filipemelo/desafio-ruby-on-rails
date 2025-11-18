
require 'rails_helper'

RSpec.describe CnabFilesController, type: :controller do
  render_views

  it 'renderiza o formulário de upload' do
    get :new
    expect(response).to be_successful
    expect(response.body).to include('Upload de Arquivo CNAB')
  end

  it 'faz upload com erro' do
    post :create, params: { cnab_file: { file: nil } }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to include('Upload de Arquivo CNAB')
  end
end
