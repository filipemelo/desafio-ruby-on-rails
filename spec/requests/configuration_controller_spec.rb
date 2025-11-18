require 'rails_helper'

RSpec.describe "Configuration", type: :request do
  it 'renderiza a tela de configuração' do
    get configuration_path
    expect(response).to be_successful
    expect(response.body).to include('Configuration')
  end
end
