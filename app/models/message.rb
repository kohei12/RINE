class Message < ActiveRecord::Base
  belongs_to :room

  validates_presence_of :text
  validates_presence_of :room
end
