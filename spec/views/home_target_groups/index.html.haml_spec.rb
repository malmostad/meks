require 'rails_helper'

RSpec.describe "home_target_groups/index", type: :view do
  before(:each) do
    assign(:home_target_groups, [
      HomeTargetGroup.create!(
        :name => "Name"
      ),
      HomeTargetGroup.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of home_target_groups" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
