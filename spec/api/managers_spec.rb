require 'rails_helper'

describe 'Managers requests:' do
  it 'should not authenticate with wrong credentials' do
    post '/api/v1/managers/sign_in', manager: attributes_for(:manager)
    expect(response.status).to eq 400
    expect(json).to have_key('error')
  end

  it 'should authenticate with right credentials' do
    manager_params = attributes_for(:manager)
    Manager.create(manager_params)
    post '/api/v1/managers/sign_in', manager: manager_params
    expect(response.status).to eq 200
    expect(json).to have_key('token')
  end

  describe 'signed in as manager' do
    before :each do
      sign_in_as(:manager)
    end

    it 'should create manager' do
      post '/api/v1/managers', { manager: attributes_for(:manager) }
      expect(response.status).to eq(200)
    end

    it 'should display all managers' do
      create(:manager)
      get '/api/v1/managers'
      expect(response.status).to eq(200)
      expect(json.count).to eq(2)
    end

    it 'should display manager' do
      manager = create(:manager)
      get "/api/v1/managers/#{manager.id}"
      expect(response.status).to eq(200)
      expect(json['manager']).to be_present
      expect(json['manager']['email']).to eq(manager.email)
    end

    it 'should update manager' do
      manager = create(:manager)
      new_email = Faker::Internet.email
      patch "/api/v1/managers/#{manager.id}", manager: { email: new_email }
      expect(response.status).to eq(200)
      expect(json['manager']).to be_present
      expect(json['manager']['email']).to eq(new_email)
      expect(manager.reload.email).to eq(new_email)
    end

    it 'should destroy manager' do
      manager = create(:manager)
      delete "/api/v1/managers/#{manager.id}"
      expect(response.status).to eq(200)
      expect(json['manager']).to be_present
      expect(Manager.count).to eq(1)
    end
  end

  describe 'signed in as employee' do
    before :each do
      sign_in_as(:employee)
    end

    it 'should not create manager' do
      post '/api/v1/managers', { manager: attributes_for(:manager) }
      expect(response.status).to eq(400)
      expect(json).to have_key('error')
    end

    it 'should not display all managers' do
      create(:manager)
      get '/api/v1/managers'
      expect(response.status).to eq(400)
      expect(json).to have_key('error')
    end

    it 'should not display manager' do
      manager = create(:manager)
      get "/api/v1/managers/#{manager.id}"
      expect(response.status).to eq(400)
      expect(json).to have_key('error')
    end

    it 'should not update manager' do
      manager = create(:manager)
      new_email = Faker::Internet.email
      patch "/api/v1/managers/#{manager.id}", manager: { email: new_email }
      expect(response.status).to eq(400)
      expect(json).to have_key('error')
    end

    it 'should destroy manager' do
      manager = create(:manager)
      delete "/api/v1/managers/#{manager.id}"
      expect(response.status).to eq(400)
      expect(Manager.count).to eq(1)
      expect(json).to have_key('error')
    end
  end
end
