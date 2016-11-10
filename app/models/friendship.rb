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

  def self.request(user, friend)
    unless user == friend || already_requested?(user, friend)
      transaction do
        create(requested_user: user, friend: friend, status: 'pending')
      end
    end
  end

  def accept(user, friend)
    unless user == friend || self.requested_user == user
      transaction do
        self.update!(
         accepted_at: Time.now,
         status: 'accepted',
         room: Room.create(user, friend, self)
        )
      end
    end
  end

  def self.already_requested?(user, friend)
    user.friendships.where(friend: friend).present?
  end
end
