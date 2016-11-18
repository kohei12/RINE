class Friendship < ActiveRecord::Base
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'
  # リクエストを送ったユーザー
  belongs_to :requested_user, class_name: 'User', foreign_key: 'user_id'
  has_one :room, dependent: :destroy

  validates :user_id,
    presence: true,
    uniqueness: { scope: :friend_id }
  validates_presence_of :friend_id
  validates_presence_of :status

  enum status: { pending: 1, accepted: 2, rejected: 3 }.freeze

  def self.already_requested?(user, friend)
    user.friendships.where(friend: friend).present?
  end

  # requests sent to current_user
  def self.unaccepted_requests(user)
    requests = self.where(friend_id: user.id)
    return unless requests
    requests.map do |request|
      if request.status == "pending"
        request
      else
        nil
      end
    end
  end

  # requests sent by current_user
  def self.waiting_requests(user)
    requests = self.where(user_id: user.id)
    return unless requests
    requests.map do |request|
      if request.status == "pending"
        request
      else
        nil
      end
    end
  end
end
