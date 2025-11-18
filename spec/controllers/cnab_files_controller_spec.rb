
require 'rails_helper'

RSpec.describe CnabFilesController, type: :controller do
  render_views

  it 'renders the upload form' do
    get :new
    expect(response).to be_successful
    expect(response.body).to include('CNAB File Upload')
  end

  it 'uploads with error' do
    post :create, params: { cnab_file: { file: nil } }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to include('CNAB File Upload')
  end
end
