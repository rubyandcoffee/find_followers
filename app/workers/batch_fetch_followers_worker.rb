class BatchFetchFollowersWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    User.all.each do |user|
      RetrieveTwitterFollowersWorker.perform_async(user.id)
    end
  end
end
