 require 'rails_helper'

RSpec.describe '/users', type: :request do

  describe 'GET /index' do
    it 'renders a successful response' do
      get users_url

      expect(response).to be_successful
    end
  end

  describe 'POST /view_followers' do
    subject { post view_followers_path, params: params }

    let(:params) { { twitter_search: { username: 'rubyandcoffee' } } }

    it 'renders a successful response', :vcr do
      subject

      expect(response).to be_successful
    end

    it 'creates a user', :vcr do
      expect { subject }.to change(User, :count).by(1)
    end

    it 'creates followers', :vcr do
      expect { subject }.to change(Follower, :count)
    end
  end
end
