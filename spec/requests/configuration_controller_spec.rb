require 'rails_helper'

RSpec.describe "Configuration", type: :request do
  it 'renders the configuration screen' do
    get configuration_path
    expect(response).to be_successful
    expect(response.body).to include('Configuration')
  end
end
