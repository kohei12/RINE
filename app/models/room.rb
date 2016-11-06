class Room < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'
  belongs_to :friendship
  has_many :messages

  validates :friendship_id,
    presence: true,
    uniqueness: true

  def self.create(user, friend)
    transaction do
      create_one_side_room(user, friend)
      create_one_side_room(friend, user)
    end
  end

  def self.create_one_side_room(user, friend)
    friendship = Friendship.find_by_user_id_and_friend_id(user ,friend)
    room = Room.new
    room.user_id = user.id
    room.friend_id = friend.id
    room.friendship_id = friendship.id
    room.save
  end

  def inverse_room(user, friend)
    Room.find_by_user_id_and_friend_id(friend, user)
  end
end
