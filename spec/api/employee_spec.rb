require 'rails_helper'

describe 'Employees' do
  it 'should not authenticate with wrong credentials' do
    post '/api/v1/employees/sign_in', employee: { email: 'employee@example.com', password: 'password' }
    expect(response.status).to eq 400
  end

  it 'should authenticate with right credentials' do
    Employee.create(email: 'employee@example.com', password: 'password')
    post '/api/v1/employees/sign_in', employee: { email: 'employee@example.com', password: 'password' }
    expect(response.status).to eq 200
  end
end
