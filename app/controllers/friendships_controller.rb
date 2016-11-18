class FriendshipsController < ApplicationController
  before_action :authenticate

  def create
    friend = User.find(params[:friend_id])
    if @request = request_friendship(friend)
      flash[:notice] = 'success!'
    else
      flash[:notice] = 'failure!'
    end
    redirect_to current_user
  end

  def update
    requested_user = User.find(params[:requested_user_id])
    if accept_friendship(requested_user)
      flash[:notice] = '友達になりました。'
    else
      flash[:notice] = '承認に失敗しました'
    end
    redirect_to current_user
  end

  def destroy
  end

  def reject
  end

  private

  def request_friendship(friend)
    unless current_user == friend || Friendship.already_requested?(current_user, friend)
      transaction do
        Friendship.create(requested_user: current_user, friend: friend, status: 'pending')
      end
    end
  end

  def accept_friendship(requested_user)
    request = Friendship.find_by(requested_user: requested_user, friend: current_user)
    unless current_user == requested_user
      transaction do
        self.update!(
         accepted_at: Time.now,
         status: 'accepted',
         room: Room.create(current_user, requested_user, self)
        )
      end
    end
  end
end
