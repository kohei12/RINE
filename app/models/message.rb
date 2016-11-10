class Message < ActiveRecord::Base
  after_create_commit { MessageBroadcastJob.perform_later self }

  #belongs_to :room
  #belongs_to :sent_user, class_name: 'User', foreign_key: 'user_id'

  validates_presence_of :text
  #validates_presence_of :sent_user
  #validates_presence_of :room
end
