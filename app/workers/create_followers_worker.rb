class CreateFollowersWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id, follower_username)
    user = User.find(user_id)
    follower = Follower.find_or_create_by(username: follower_username)

    user.followers << follower unless follower_exists?(user, follower_username)
  end

  private

  def follower_exists?(user, follower_username)
    user.followers.where(username: follower_username).exists?
  end
end
