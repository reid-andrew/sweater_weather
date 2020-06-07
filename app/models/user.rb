class User < ApplicationRecord
  validates_presence_of :email
  validates :email, uniqueness: true
  validates_presence_of :password, on: :create

  before_create :set_api_key

  has_secure_password

  def set_api_key
    self.api_key = generate_api_key
  end

  def generate_api_key
    SecureRandom.base58(24)
  end
end
