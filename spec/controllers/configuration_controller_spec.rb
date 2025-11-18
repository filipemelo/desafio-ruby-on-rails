require 'rails_helper'

RSpec.describe ConfigurationController, type: :controller do

  it 'does not reset without confirmation' do
    post :reset_database, params: { confirmation_text: 'wrong' }
    expect(flash[:alert]).to be_present
    expect(response).to redirect_to(configuration_path)
  end

  it 'resets with confirmation' do
    post :reset_database, params: { confirmation_text: 'CONFIRMAR' }
    expect(flash[:notice]).to be_present
    expect(response).to redirect_to(configuration_path)
  end
end
