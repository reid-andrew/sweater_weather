require 'rails_helper'

RSpec.describe 'Registration Endpoint -', type: :request do
  before(:each) do
    @expected = File.read('spec/fixtures/registration/registration.json')
    @starting_user_count = User.count
  end

  it 'registers a user' do
    post '/api/v1/users'
    {
      "email": "whatever@example.com",
      "password": "password",
      "password_confirmation": "password"
    }
    output = JSON.parse(response.body)

    expect(response).to be_successful
    expect(response.status).to eq('201')
    expect(output).to eq(@expected)
    expect(User.count - @starting_user_count).to eq(1)
    expect(User.last.email).to eq("whatever@example.com")
  end
end
