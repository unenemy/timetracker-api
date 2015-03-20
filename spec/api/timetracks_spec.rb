require 'rails_helper'

describe 'Timetracks requests:' do

  context 'signed in as employee' do
    before :each do
      sign_in_as(:employee)
      @me = Token.find_by_token(@token).user
    end

    it 'should display list of my timetracks' do
      some_other_employee = create(:employee)
      some_other_employee.timetracks.create(attributes_for(:timetrack))
      2.times { @me.timetracks.create(attributes_for(:timetrack)) }
      get '/api/v1/timetracks'
      expect(response.status).to eq(200)
      expect(json['timetracks'].count).to eq(2)
    end

    it 'should display my timetrack' do
      timetrack = @me.timetracks.create(attributes_for(:timetrack))
      get "/api/v1/timetracks/#{timetrack.id}"
      expect(response.status).to eq(200)
      expect(json).to have_key('timetrack')
    end

    it 'should not display another employee\'s timetrack' do
      some_other_employee = create(:employee)
      timetrack = some_other_employee.timetracks.create(attributes_for(:timetrack))
      get "/api/v1/timetracks/#{timetrack.id}"
      expect(response.status).to eq(404)
      expect(json).to have_key('error')
    end

    it 'should create timetrack' do
      post '/api/v1/timetracks', timetrack: attributes_for(:timetrack)
      expect(@me.timetracks.count).to eq(1)
    end

    it 'should update his own timetrack' do
      timetrack = @me.timetracks.create(attributes_for(:timetrack))
      new_description = 'Some new description'
      patch "/api/v1/timetracks/#{timetrack.id}", timetrack: { description: new_description }
      expect(response.status).to eq(200)
      expect(timetrack.reload.description).to eq(new_description)
    end

    it 'should not update another employee\'s timetrack' do
      some_other_employee = create(:employee)
      timetrack = some_other_employee.timetracks.create(attributes_for(:timetrack))
      new_description = 'Some new description'
      patch "/api/v1/timetracks/#{timetrack.id}", timetrack: { description: new_description }
      expect(response.status).to eq(404)
      expect(timetrack.reload.description).to_not eq(new_description)
    end

    it 'should delete his own timetrack' do
      timetrack = @me.timetracks.create(attributes_for(:timetrack))
      delete "/api/v1/timetracks/#{timetrack.id}"
      expect(response.status).to eq(200)
      expect(@me.timetracks.count).to eq(0)
    end

    it 'should not delete another employee\'s timetrack' do
      some_other_employee = create(:employee)
      timetrack = some_other_employee.timetracks.create(attributes_for(:timetrack))
      delete "/api/v1/timetracks/#{timetrack.id}"
      expect(response.status).to eq(404)
      expect(some_other_employee.timetracks.count).to eq(1)
    end
  end

  context 'signed in as manager' do
    before :each do
      sign_in_as(:manager)
      @me = Token.find_by_token(@token).user
    end

    it 'should display list of all timetracks' do
      3.times do
        some_other_employee = create(:employee)
        some_other_employee.timetracks.create(attributes_for(:timetrack))
      end
      get '/api/v1/timetracks'
      expect(response.status).to eq(200)
      expect(json['timetracks'].count).to eq(3)
    end

    it 'should display any timetrack' do
      some_other_employee = create(:employee)
      timetrack = some_other_employee.timetracks.create(attributes_for(:timetrack))
      get "/api/v1/timetracks/#{timetrack.id}"
      expect(response.status).to eq(200)
      expect(json).to have_key('timetrack')
    end

    it 'should create timetrack' do
      some_other_employee = create(:employee)
      post '/api/v1/timetracks', timetrack: attributes_for(:timetrack).merge(employee_id: some_other_employee.id)
      expect(some_other_employee.timetracks.count).to eq(1)
    end

    it 'should update timetrack' do
      some_other_employee = create(:employee)
      timetrack = some_other_employee.timetracks.create(attributes_for(:timetrack))
      new_description = 'Some new description'
      patch "/api/v1/timetracks/#{timetrack.id}", timetrack: { description: new_description }
      expect(response.status).to eq(200)
      expect(timetrack.reload.description).to eq(new_description)
    end

    it 'should delete timetrack' do
      some_other_employee = create(:employee)
      timetrack = some_other_employee.timetracks.create(attributes_for(:timetrack))
      delete "/api/v1/timetracks/#{timetrack.id}"
      expect(response.status).to eq(200)
      expect(some_other_employee.timetracks.count).to eq(0)
    end
  end
end
