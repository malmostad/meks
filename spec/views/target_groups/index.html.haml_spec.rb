require 'rails_helper'

RSpec.describe "target_groups/index", type: :view do
  before(:each) do
    assign(:target_groups, [
      TargetGroup.create!(
        :name => "Name"
      ),
      TargetGroup.create!(
        :name => "Name 2"
      )
    ])
  end

  it "renders a list of target_groups" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 1
    assert_select "tr>td", :text => "Name 2".to_s, :count => 1
  end
end
