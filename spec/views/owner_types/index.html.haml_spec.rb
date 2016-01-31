require 'rails_helper'

RSpec.describe "owner_types/index", type: :view do
  before(:each) do
    assign(:owner_types, [
      OwnerType.create!(
        :name => "Name"
      ),
      OwnerType.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of owner_types" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
