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
    request = current_user.requested_friendships.find_by(user_id: params[:requested_user_id])
    if request.destroy
      flash.now[:notice] = "却下しました"
    else
      flash.now[:notice] = "却下に失敗しました"
    end
    redirect_to current_user
  end

  private

  def request_friendship(friend)
    unless current_user == friend || Friendship.already_requested?(current_user, friend)
      Friendship.transaction do
        Friendship.create(requested_user: current_user, friend: friend, status: 'pending')
      end
    end
  end

  def accept_friendship(requested_user)
    request = current_user.requested_friendships.find_by(requested_user: requested_user)
    if current_user.can_accept?(request)
      Friendship.transaction do
        request.update!(
         accepted_at: Time.now,
         status: 'accepted',
         room: Room.create!(friendship_id: request.id)
        )
      end
    end
  end
end
