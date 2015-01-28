require 'rails_helper'

describe 'Employees' do
  it 'should not authenticate with wrong credentials' do
    post '/api/v1/employees/sign_in', employee: { email: 'employee@example.com', password: 'password' }
    expect(response.status).to eq 400
    expect(json).to have_key(:error)
  end

  it 'should authenticate with right credentials' do
    Employee.create(email: 'employee@example.com', password: 'password')
    post '/api/v1/employees/sign_in', employee: { email: 'employee@example.com', password: 'password' }
    expect(response.status).to eq 200
    expect(json).to have_key(:token)
  end
end
