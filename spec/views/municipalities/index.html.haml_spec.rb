require 'rails_helper'

RSpec.describe "municipalities/index", type: :view do
  before(:each) do
    assign(:municipalities, [
      Municipality.create!(
        :name => "Name"
      ),
      Municipality.create!(
        :name => "Name 2"
      )
    ])
  end

  it "renders a list of municipalities" do
    render
    assert_select "tr>td", :text => "Name", :count => 1
    assert_select "tr>td", :text => "Name 2", :count => 1
  end
end
