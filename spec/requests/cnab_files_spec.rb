require 'rails_helper'

RSpec.describe "CnabFiles", type: :request do
  it 'renders the upload form' do
    get new_cnab_file_path
    expect(response).to be_successful
    expect(response.body).to include('CNAB File Upload')
  end

  it 'uploads invalid file and shows error' do
    post cnab_files_path, params: { cnab_file: { file: nil } }
    expect(response.body).to include('CNAB File Upload')
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it 'uploads valid file and redirects to stores' do
    file = fixture_file_upload(Rails.root.join('spec/fixtures/files/cnab.txt'), 'text/plain')
    post cnab_files_path, params: { cnab_file: { file: file } }
    expect(response).to redirect_to(stores_path)
    follow_redirect!
    expect(response.body).to include('Stores and Transactions')
  end
end
