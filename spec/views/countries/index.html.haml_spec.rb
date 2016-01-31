require 'rails_helper'

RSpec.describe "countries/index", type: :view do
  before(:each) do
    assign(:countries, [
      Country.create!(
        :name => "Name"
      ),
      Country.create!(
        :name => "Name 2"
      )
    ])
  end

  it "renders a list of countries" do
    render
    assert_select "tr>td", :text => "Name", :count => 1
    assert_select "tr>td", :text => "Name 2", :count => 1
  end
end
