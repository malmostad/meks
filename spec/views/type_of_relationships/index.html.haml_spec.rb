require 'rails_helper'

RSpec.describe "type_of_relationships/index", type: :view do
  before(:each) do
    assign(:type_of_relationships, [
      TypeOfRelationship.create!(
        :name => "Name"
      ),
      TypeOfRelationship.create!(
        :name => "Name 2"
      )
    ])
  end

  it "renders a list of type_of_relationships" do
    render
    assert_select "tr>td", :text => "Name", :count => 1
    assert_select "tr>td", :text => "Name 2", :count => 1
  end
end
