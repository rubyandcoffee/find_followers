 require 'rails_helper'

RSpec.describe '/users', type: :request do
  describe '#view_followers' do
    subject { post view_followers_path, params: params }

    let(:params) { { twitter_search: { username: 'rubyandcoffee' } } }

    it 'creates a user', :vcr do
      expect { subject }.to change(User, :count).by(1)
    end

    it 'creates followers', :vcr do
      expect { subject }.to change(Follower, :count).by(80)
    end
  end
end
