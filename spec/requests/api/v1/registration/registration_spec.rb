require 'rails_helper'

RSpec.describe 'Registration Endpoint -', type: :request do
  before(:each) do
    @starting_user_count = User.count
  end

  it 'registers a user' do
    post '/api/v1/users', params:
      {
        "email": "whatever@example.com",
        "password": "password",
        "password_confirmation": "password"
      }
    output = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(201)
    expect(output[:data][:id]).to eq(User.last.id.to_s)
    expect(output[:data][:type]).to eq('users')
    expect(output[:data][:attributes][:email]).to eq('whatever@example.com')
    expect(output[:data][:attributes][:api_key]).to eq(User.last.api_key)
    expect(User.count - @starting_user_count).to eq(1)
    expect(User.last.email).to eq("whatever@example.com")
  end

  it 'prevents multiple registrations with the same email' do
    post '/api/v1/users', params:
      {
        "email": "whatever@example.com",
        "password": "password",
        "password_confirmation": "password"
      }

      expect(response).to be_successful

      post '/api/v1/users', params:
        {
          "email": "whatever@example.com",
          "password": "password",
          "password_confirmation": "password"
        }
      output = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(output[:data][:attributes][:error]).to eq('This email is already registered.')
  end

  it 'prevents registration with mismatching passwords' do
    post '/api/v1/users', params:
      {
        "email": "whatever@example.com",
        "password": "password",
        "password_confirmation": "not_password"
      }

      output = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(output[:data][:attributes][:error]).to eq('Passwords must match.')
  end

  it 'prevents registration with missing info' do
    post '/api/v1/users', params:
      {
        "email": "whatever@example.com"
      }

      output = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(output[:data][:attributes][:error]).to eq('Complete all fields.')

      post '/api/v1/users', params:
        {
          "password": "password",
          "password_confirmation": "password"
        }

        output = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(400)
        expect(output[:data][:attributes][:error]).to eq('Complete all fields.')
  end
end
