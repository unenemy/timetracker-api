require 'rails_helper'

describe 'Employees' do
  it 'should not authenticate with wrong credentials' do
    post '/api/v1/employees/sign_in', employee: attributes_for(:employee)
    expect(response.status).to eq 400
    expect(json).to have_key(:error)
  end

  it 'should authenticate with right credentials' do
    employee_params = attributes_for(:employee)
    Employee.create(employee_params)
    post '/api/v1/employees/sign_in', employee: employee_params
    expect(response.status).to eq 200
    expect(json).to have_key(:token)
  end
end
