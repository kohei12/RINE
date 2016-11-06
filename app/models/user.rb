class User < ActiveRecord::Base
  attr_accessor :auth_token, :password
  before_create { generate_token(:auth_token) }
  before_save :encrypt_password

  validates_presence_of :password, on: :create
  validates_confirmation_of :password
  validates :email,
    uniqueness: true
  validates_presence_of :name

  has_many :friends, through: :friendships
  has_many :friendships, dependent: :destroy
  has_many :messages, through: :friendships
  has_many :rooms, through: :friendships, dependent: :destroy

  def self.authenticate(email, password)
    user = User.find_by(email: email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  private

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
end
