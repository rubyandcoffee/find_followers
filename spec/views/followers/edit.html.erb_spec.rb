require 'rails_helper'

RSpec.describe "followers/edit", type: :view do
  before(:each) do
    @follower = assign(:follower, Follower.create!(
      username: "MyString"
    ))
  end

  it "renders the edit follower form" do
    render

    assert_select "form[action=?][method=?]", follower_path(@follower), "post" do

      assert_select "input[name=?]", "follower[username]"
    end
  end
end
