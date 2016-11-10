class Room < ActiveRecord::Base
  belongs_to :friendship
  has_many :messages

  validates :friendship_id,
    presence: true,
    uniqueness: true

  def self.create(user, friend, friendship)
    room = Room.new
    room.friendship = friendship
    room.save
    room
  end
end
