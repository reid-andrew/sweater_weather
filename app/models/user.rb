class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, on: :create
  validates :password_confirmation, presence: true, on: :create

  has_many :road_trips, dependent: :destroy

  before_create :set_api_key

  has_secure_password

  def set_api_key
    self.api_key = generate_api_key
  end

  def generate_api_key
    SecureRandom.base58(24)
  end

  def error
    return 'This email is already registered.' if User.find_by(email: email)

    return 'Passwords must match.' if password != password_confirmation

    return 'Complete all fields.' if !email || !password

    'Something went wrong. Please double check your email and password and try again.'
  end
end
