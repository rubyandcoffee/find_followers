require 'rails_helper'

RSpec.describe TwitterFollowerAdapter do
  subject { described_class.adapt(username) }

  let(:username) { 'rubyandcoffee' }

  describe '#adapt' do
    it 'returns an array', :vcr do
      expect(subject).to be_an(Array)
    end

    it 'returns a list of follower usernames', :vcr do
      expect(subject).to include(a_kind_of(String))
    end
  end
end
