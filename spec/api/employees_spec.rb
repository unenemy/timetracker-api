require 'rails_helper'

describe 'Employees requests:' do
  it 'should not authenticate with wrong credentials' do
    post '/api/v1/employees/sign_in', employee: attributes_for(:employee)
    expect(response.status).to eq(400)
    expect(json).to have_key('error')
  end

  it 'should authenticate with right credentials' do
    employee_params = attributes_for(:employee)
    Employee.create(employee_params)
    post '/api/v1/employees/sign_in', employee: employee_params
    expect(response.status).to eq(200)
    expect(json).to have_key('token')
  end

  it 'should create employee with proper params' do
    post '/api/v1/employees', employee: { email: 'test@example.com', password: 'password', password_confirmation: 'password' }
    expect(response.status).to eq(200)
    expect(Employee.count).to eq(1)
    expect(json).to have_key('employee')
  end

  it 'should not create employee with unvalid params' do
    post '/api/v1/employees', employee: { email: 'test@example.com', password: 'password', password_confirmation: 'not real password' }
    expect(response.status).to eq(422)
    expect(Employee.count).to eq(0)
    expect(json).to have_key('errors')
  end

  describe 'signed in as employee' do
    before :each do
      sign_in_as(:employee)
      @me = Token.find_by_token(@token).user
    end

    it 'should update myself' do
      new_email = Faker::Internet.email
      patch "/api/v1/employees/#{@me.id}", employee: { email: new_email }
      expect(response.status).to eq(200)
      expect(json).to have_key('employee')
      expect(json['employee']['email']).to eq(new_email)
      expect(@me.reload.email).to eq(new_email)
    end

    it 'should not update other employee' do
      new_email = Faker::Internet.email
      employee = create(:employee)
      patch "/api/v1/employees/#{employee.id}", employee: { email: new_email }
      expect(response.status).to eq(400)
      expect(json).to have_key('error')
      expect(employee.reload.email).to_not eq(new_email)
    end

    it 'should not delete employee' do
      delete "/api/v1/employees/#{@me.id}"
      expect(response.status).to eq(400)
      expect(json).to have_key('error')
    end

    it 'should display employee' do
      employee = create(:employee)
      get "/api/v1/employees/#{employee.id}"
      expect(response.status).to eq(200)
      expect(json).to have_key('employee')
      expect(json['employee']['email']).to eq(employee.email)
    end

    it 'should display employees list' do
      create(:employee)
      get '/api/v1/employees'
      expect(response.status).to eq(200)
      expect(json.count).to eq(2)
    end
  end

  describe 'signed in as manager' do
    before :each do
      sign_in_as(:manager)
      @me = Token.find_by_token(@token).user
    end

    it 'should update other employee' do
      new_email = Faker::Internet.email
      employee = create(:employee)
      patch "/api/v1/employees/#{employee.id}", employee: { email: new_email }
      expect(response.status).to eq(200)
      expect(json).to have_key('employee')
      expect(employee.reload.email).to eq(new_email)
    end

    it 'should delete employee' do
      employee = create(:employee)
      delete "/api/v1/employees/#{employee.id}"
      expect(response.status).to eq(200)
      expect(json).to have_key('employee')
    end

    it 'should display employee' do
      employee = create(:employee)
      get "/api/v1/employees/#{employee.id}"
      expect(response.status).to eq(200)
      expect(json).to have_key('employee')
      expect(json['employee']['email']).to eq(employee.email)
    end

    it 'should display employees list' do
      create(:employee)
      get '/api/v1/employees'
      expect(response.status).to eq(200)
      expect(json.count).to eq(1)
    end
  end
end
