require 'rails_helper'

RSpec.describe "followers/index", type: :view do
  before(:each) do
    assign(:followers, [
      Follower.create!(
        username: "Username"
      ),
      Follower.create!(
        username: "Username"
      )
    ])
  end

  it "renders a list of followers" do
    render
    assert_select "tr>td", text: "Username".to_s, count: 2
  end
end
