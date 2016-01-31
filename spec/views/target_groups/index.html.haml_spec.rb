require 'rails_helper'

RSpec.describe "target_group/index", type: :view do
  before(:each) do
    assign(:target_group, [
      TargetGroup.create!(
        :name => "Name"
      ),
      TargetGroup.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of target_group" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
