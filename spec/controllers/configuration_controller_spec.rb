require 'rails_helper'

RSpec.describe ConfigurationController, type: :controller do

  it 'não reseta sem confirmação' do
    post :reset_database, params: { confirmation_text: 'errado' }
    expect(flash[:alert]).to be_present
    expect(response).to redirect_to(configuration_path)
  end

  it 'reseta com confirmação' do
    post :reset_database, params: { confirmation_text: 'CONFIRMAR' }
    expect(flash[:notice]).to be_present
    expect(response).to redirect_to(configuration_path)
  end
end
