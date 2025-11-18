require 'rails_helper'

describe Store, type: :model do
  it 'is invalid without name' do
    store = Store.new(owner: 'John Doe')
    expect(store).not_to be_valid
  end

  it 'is invalid without owner' do
    store = Store.new(name: 'Store 1')
    expect(store).not_to be_valid
  end

  it 'is valid with name and owner' do
    store = Store.new(name: 'Store 1', owner: 'John Doe')
    expect(store).to be_valid
  end
end
