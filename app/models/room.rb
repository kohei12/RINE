class Room < ActiveRecord::Base
  belongs_to :friendship
  has_many :messages

  validates :friendship_id,
    presence: true,
    uniqueness: true
end
