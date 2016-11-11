class Message < ActiveRecord::Base
  after_create_commit { BroadcastMessageJob.perform_later self }

  belongs_to :sent_user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :room

  validates_presence_of :content
  validates_presence_of :sent_user
  validates_presence_of :room
end
