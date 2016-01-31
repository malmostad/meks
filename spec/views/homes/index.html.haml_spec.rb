require 'rails_helper'

RSpec.describe "homes/index", type: :view do
  before(:each) do
    assign(:homes, [
      Home.create!(
        :name => "Name",
        :phone => "Phone",
        :fax => "Fax",
        :address => "Address",
        :post_code => "Post Code",
        :postal_town => "Postal Town",
        :type_of_housing => nil,
        :owner_type => nil,
        :target_group => nil,
        :seats => 1,
        :guaranteed_seats => 2,
        :movable_seats => 3,
        :languages => "Languages",
        :comment => "MyText"
      ),
      Home.create!(
        :name => "Name",
        :phone => "Phone",
        :fax => "Fax",
        :address => "Address",
        :post_code => "Post Code",
        :postal_town => "Postal Town",
        :type_of_housing => nil,
        :owner_type => nil,
        :target_group => nil,
        :seats => 1,
        :guaranteed_seats => 2,
        :movable_seats => 3,
        :languages => "Languages",
        :comment => "MyText"
      )
    ])
  end

  it "renders a list of homes" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Fax".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "Post Code".to_s, :count => 2
    assert_select "tr>td", :text => "Postal Town".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Languages".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
