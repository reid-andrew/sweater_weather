class User < ApplicationRecord
  validates_presence_of :email
  validates :email, uniqueness: true
  validates_presence_of :password, on: :create

  has_secure_password

  def api_key
    "xyz"
  end
end
