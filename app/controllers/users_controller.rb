class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :set_followers, only: [:view_followers]
  rescue_from ActionController::InvalidAuthenticityToken, with: :redirect_to_referer_or_path
  rescue_from Twitter::Error::TooManyRequests, with: :too_many_requests_error

  def index
    @users = User.all
  end

  def show
  end

  def view_followers
    @followers.each do |follower_username|
      CreateFollowersWorker.perform_async(user.id, follower_username)
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_followers
    @followers = TwitterFollowerAdapter.adapt(user.username)
  end

  def twitter_search_params
    params.require(:twitter_search).permit(:username)
  end

  def username
    twitter_search_params.fetch(:username)
  end

  def user
    @user ||= User.find_or_create_by(username: username)
  end

  def redirect_to_referer_or_path
    flash[:notice] = "Sorry, the app has had a little hiccup! Please try again."

    redirect_to request.referer
  end

  def too_many_requests_error
    flash[:notice] = "Sorry, too many requests! Please try again later - this may take upwards of one hour."

    redirect_to root_url
  end
end
