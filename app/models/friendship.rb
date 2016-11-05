class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

  validates :user_id,
    uniqueness: { scope: :friend_id }
  validates_presence_of :status

  enum status: { 'pending': 1, 'requested': 2, 'accepted': 3 }.freeze

  def self.request(user, friend)
    unless user == friend || inverse_request(user, friend).present? || already_requested?(user, friend)
      transaction do
        create(user: user, friend: friend, status: 'pending')
        create(user: friend, friend: user, status: 'requested')
      end
    end
  end

  def accept(user, friend)
    transaction do
      accepted_at = Time.now
      accept_one_side(user, friend, accepted_at)
      accept_one_side(friend, user, accepted_at)
    end
  end

  def accept_one_side(user, friend, accepted_at)
    request = Friendship.find_by_user_id_and_friend_id(user ,friend)
    request.status = 'accepted'
    request.accepted_at = accepted_at
    request.save!
  end

  def self.inverse_request(user, friend)
    find_by_user_id_and_friend_id(friend, user)
  end

  def self.already_requested?(user, friend)
    user.friendships.where(friend: friend).present?
  end
end
