require 'rails_helper'

RSpec.describe 'Login Endpoint -', type: :request do
  before(:each) do
    params = {"email": "whatever@example.com", "password": "password", "password_confirmation": "password"}
    @user = User.create!(params)
  end

  it 'logs in a registered user' do
    post '/api/v1/sessions', params:
      {
        "email": "whatever@example.com",
        "password": "password"
      }
    output = JSON.parse(response.body, symbolize_names: true)
    user = User.find_by(email: "whatever@example.com")

    expect(response).to be_successful
    expect(response.status).to eq(201)
    expect(output[:data][:id]).to eq(User.last.id.to_s)
    expect(output[:data][:type]).to eq('users')
    expect(output[:data][:attributes][:email]).to eq(user.email)
    expect(output[:data][:attributes][:api_key]).to eq(user.api_key)
  end

  it 'handles failed logins because bad email provided' do
    post '/api/v1/sessions', params:
    {
      "email": "alternative@example.com",
      "password": "password"
    }

    output = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(400)
    expect(output[:data][:attributes][:error]).to eq('Please register first.')
  end

  it 'handles failed logins because bad password provided' do
    post '/api/v1/sessions', params:
    {
      "email": "whatever@example.com",
      "password": "not_password"
    }

    output = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(400)
    expect(output[:data][:attributes][:error]).to eq('Please register first.')
  end

  it 'handles failed logins because no info provided' do
    post '/api/v1/sessions', params: {}

    output = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(400)
    expect(output[:data][:attributes][:error]).to eq('Please provide a password and email.')
  end
end
