require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        :username => "name",
        :name => "Name",
        :role => 'admin'
      ),
      User.create!(
        :username => "name2",
        :name => "Name 2",
        :role => 'writer'
      ),
      User.create!(
        :username => "name3",
        :name => "Name 3",
        :role => 'reader'
      )
    ])
  end

  it "renders a list of type_of_relationships" do
    render
    assert_select "tr>td", :text => "Name", :count => 1
    assert_select "tr>td", :text => "admin", :count => 1
    assert_select "tr>td", :text => "Name 2", :count => 1
    assert_select "tr>td", :text => "writer", :count => 1
    assert_select "tr>td", :text => "Name 3", :count => 1
    assert_select "tr>td", :text => "reader", :count => 1
  end
end
