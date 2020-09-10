class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :set_followers, only: [:view_followers]
  rescue_from ActionController::InvalidAuthenticityToken, with: :redirect_to_referer_or_path

  def index
    @users = User.all
  end

  def show
  end

  def view_followers
    begin
      @followers.each do |follower|
        CreateFollowersWorker.perform_async(user.id, follower.screen_name)
      end
    rescue Twitter::Error::TooManyRequests => error
      @followers = []
      flash.now[:notice] = too_many_requests(error)
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_followers
    @followers = client.followers(user.username)
  end

  def client
    @client ||= TwitterClient.client
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

  def too_many_requests(error)
    <<-ERROR
    Error fetching Twitter followers: #{error}.
    These will automatically be processed so you will be able to see them
    on the user page shortly.
    ERROR
  end

  def redirect_to_referer_or_path
    flash[:notice] = "Sorry, the app has had a little hiccup! Please try again."

    redirect_to request.referer
  end
end
