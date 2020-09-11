class RetrieveTwitterFollowersWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id)
    user = User.find(user_id)

    begin
      followers = client.followers(user.username)
      followers.each { |f| CreateFollowersWorker.perform_async(user.id, f.screen_name) }
      p "Followers for #{user.username} updated."
    rescue Twitter::Error::TooManyRequests => error
      p "Error fetching Twitter followers for #{user.username}: #{error}."
    end
  end

  private

  def client
    TwitterClient.client
  end
end
