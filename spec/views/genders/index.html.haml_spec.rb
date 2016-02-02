require 'rails_helper'

RSpec.describe "genders/index", type: :view do
  before(:each) do
    assign(:genders, [
      Gender.create!(
        :name => "Name"
      ),
      Gender.create!(
        :name => "Name 2"
      )
    ])
  end

  it "renders a list of genders" do
    render
    assert_select "tr>td", :text => "Name", :count => 1
    assert_select "tr>td", :text => "Name 2", :count => 1
  end
end
