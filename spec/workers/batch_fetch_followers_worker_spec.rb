require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe BatchFetchFollowersWorker, type: :worker do
  describe '#perform' do
    it { is_expected.to be_processed_in :default }
  end
end
