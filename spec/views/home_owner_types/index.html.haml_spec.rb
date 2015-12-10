require 'rails_helper'

RSpec.describe "home_owner_types/index", type: :view do
  before(:each) do
    assign(:home_owner_types, [
      HomeOwnerType.create!(
        :name => "Name"
      ),
      HomeOwnerType.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of home_owner_types" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
