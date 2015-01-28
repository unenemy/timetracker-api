require 'rails_helper'

describe 'Managers' do
  it 'should not authenticate with wrong credentials' do
    post '/api/v1/managers/sign_in', manager: attributes_for(:manager)
    expect(response.status).to eq 400
    expect(json).to have_key(:error)
  end

  it 'should authenticate with right credentials' do
    manager_params = attributes_for(:manager)
    Manager.create(manager_params)
    post '/api/v1/managers/sign_in', manager: manager_params
    expect(response.status).to eq 200
    expect(json).to have_key(:token)
  end
end
