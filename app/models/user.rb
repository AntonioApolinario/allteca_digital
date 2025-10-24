class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  has_many :materials, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def generate_jwt
    # Usar a mesma abordagem que o ApplicationController
    secret = ENV.fetch("DEVISE_JWT_SECRET_KEY") { "test_secret_key_1234567890" }
    payload = { 
      sub: id,
      scp: 'user',
      iat: Time.now.to_i,
      exp: 30.days.from_now.to_i,
      jti: SecureRandom.uuid
    }
    JWT.encode(payload, secret, 'HS256')
  end
end
