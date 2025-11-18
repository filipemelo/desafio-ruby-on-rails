require 'rails_helper'

RSpec.describe StoresController, type: :controller do
  render_views

  it 'displays empty message when there are no stores' do
    get :index
    expect(response.body).to include('No data to display')
  end

  it 'displays stores when they exist' do
    Store.create!(name: 'Test Store', owner: 'John Doe')
    get :index
    expect(response.body).to include('Test Store')
  end
end
