class User < ActiveRecord::Base
  attr_accessor :password
  before_save :encrypt_password

  validates_presence_of :password, on: :create
  validates_confirmation_of :password
  validates :email,
    uniqueness: true
  validates_presence_of :name

  has_many :friends, through: :friendships
  # リクエストを送ったユーザー
  has_many :requested_users, through: :requested_friendships
  has_many :friendships, dependent: :destroy, foreign_key: 'user_id'
  # 自分に送られたリクエスト
  has_many :requested_friendships, class_name: 'Friendship', dependent: :destroy, foreign_key: 'friend_id'
  has_many :messages

  def self.authenticate(email, password)
    user = User.find_by(email: email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def can_request_to?(friend)
    if friendship_with(friend).present?
      false
    else
      true
    end
  end

  def can_accept?(request)
    if self == request.requested_user
      false
    else
      true
    end
  end

  def my_friendships
    Friendship.search_for_friendship([:user_id, :friend_id], self.id)
  end

  def friendship_with(friend)
    my_friendships.find_by("user_id or friend_id", friend.id, friend.id)
  end

  def unaccepted_requests
    self.requested_friendships.where(status: :pending)
  end

  def waiting_requests
    self.friendships.where(status: :pending)
  end

  private

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
