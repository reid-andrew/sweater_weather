require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:email)}
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password)}
  end

  describe "relationships" do
    it { should have_many(:road_trips)}
  end

  describe "model methods" do
    it 'set_api_key' do
      params = {"email": "whatever@example.com", "password": "password", "password_confirmation": "password"}
      user = User.create!(params)
      expect(user.api_key).to_not eq(nil)
    end

    it '.generate_api_key' do
      expect(User.new.generate_api_key.length).to eq(24)
    end

    describe '.error' do
      it 'duplicate email' do
        params = {"email": "whatever@example.com", "password": "password", "password_confirmation": "password"}
        User.create!(params)
        expect(User.create(params).error).to eq('This email is already registered.')
      end

      it 'password mismatch' do
        params = {"email": "whatever@example.com", "password": "password", "password_confirmation": "not_password"}
        expect(User.create(params).error).to eq('Passwords must match.')
      end

      it 'incomplete fields' do
        params = {"email": "whatever@example.com"}
        expect(User.create(params).error).to eq('Complete all fields.')
      end
    end
  end
end
