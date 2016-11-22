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

  scope :search_for_friendship, lambda { |fields, name|
    conditions = nil
    fields = [fields] if fields.class == Symbol
    fields.each do |field|
      if conditions.nil?
        conditions = arel_table[field].eq(name)
      else
        conditions = conditions.or(arel_table[field].eq(name))
      end
    end
    where(conditions)
  }

  enum status: { pending: 1, accepted: 2 }.freeze

  def self.already_requested?(user, friend)
    user.friendships.where(friend: friend).present?
  end
end
