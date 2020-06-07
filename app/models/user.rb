class User < ApplicationRecord
  validates_presence_of :email
  validates :email, uniqueness: true
  validates_presence_of :password, on: :create
  validates_presence_of :password_confirmation, on: :create

  before_create :set_api_key

  has_secure_password

  def set_api_key
    self.api_key = generate_api_key
  end

  def generate_api_key
    SecureRandom.base58(24)
  end

  def error
    return 'This email is already registered.' if User.find_by(email:self.email)

    return 'Passwords must match.' if self.password != self.password_confirmation

    return 'Complete all fields.' if !self.email || !self.password

    'Something went wrong, please try again.'
  end
end
