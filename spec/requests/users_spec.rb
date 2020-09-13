require 'rails_helper'

RSpec.describe '/users', type: :request do
  describe 'GET /index' do
    subject { get users_path }

    it 'renders a successful response' do
      subject

      expect(response).to be_successful
    end

    it 'has a status of 200 OK' do
      subject

      expect(response.status).to eq(200)
    end
  end

  describe 'GET /show' do
    let(:user) { User.create }

    subject { get user_url(user) }

    it 'renders a successful response' do
      subject

      expect(response).to be_successful
    end

    it 'has a status of 200 OK' do
      subject

      expect(response.status).to eq(200)
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
