class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  rescue_from ActionController::InvalidAuthenticityToken, with: :redirect_to_referer_or_path

  def index
    @users = User.all
  end

  def show
  end

  def view_followers
    begin
      @followers = client.followers(user.username)

      @followers.each do |follower|
        find_or_create_followers(user, follower.screen_name)
      end
    rescue Twitter::Error::TooManyRequests => error
      @followers = []
      flash.now[:notice] = too_many_requests(error, user)
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
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

  def find_or_create_followers(user, screen_name)
    follower = Follower.find_or_create_by(username: screen_name)

    if user.followers.where(username: follower.username).exists?
      p "Follower #{follower.username} already in database."
    else
      user.followers << follower
      p "Follower #{follower.username} created."
    end
  end

  def too_many_requests(error, user)
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
