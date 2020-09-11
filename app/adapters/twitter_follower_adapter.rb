class TwitterFollowerAdapter
  attr_accessor :username
  private :username

  def initialize(username)
    @username = username
  end

  def self.adapt(username)
    new(username).adapt
  end

  def adapt
    followers.each_with_object([]) do |follower, arr|
      arr << follower.screen_name
    end
  end

  private

  def client
    @client ||= TwitterClient.client
  end

  def followers
    @followers ||= client.followers(username)
  end
end
