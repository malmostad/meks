require 'rails_helper'

RSpec.describe "home_types/index", type: :view do
  before(:each) do
    assign(:home_types, [
      HomeType.create!(
        :name => "Name"
      ),
      HomeType.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of home_types" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
