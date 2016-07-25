class ConnectionsController < ApplicationController
  before_action :logged_in_access

  def index
    @connections = current_user.friends
  end

  def search
    @user = User.find_by(email: search_params[:search_term])
    if @user
      redirect_to user_path(@user)
    else
      # redirect_back(fallback_location: fallback_location)
      redirect_to :back
      flash[:no_result] = "No Results for #{search_params[:search_term]}"
      p flash
    end
  end

  def direct
    @other_user = User.find(params[:id])
    current_user.friend_request(@other_user)
    current_user.friendships.last.update(direct_add: true)
    @other_user.friendships.last.update(direct_add: true)
    flash[:friending] = "Your request has been sent to #{@other_user.username}"
    logger.info "I AM REDIRECTING TO USER SHOW"
    redirect_to user_path(@other_user)
  end

  def direct_accept
    @other_user = User.find(params[:id])
    current_user.accept_request(@other_user)
    redirect_to :back
    flash[:friending] = "Your now connected to #{@other_user.username}!"
  end

  def direct_decline
    @other_user = User.find(params[:id])
    current_user.decline_request(@other_user)
    redirect_to :back
    flash[:friending] = "You have declined connection with #{@other_user.username}"
  end

  def search_params
    params.require(:search).permit(:search_term)
  end
end
