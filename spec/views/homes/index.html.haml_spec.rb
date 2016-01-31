require 'rails_helper'

RSpec.describe "homes/index", type: :view do
  before(:each) do
    assign(:homes, [
      Home.create!(
        :name => "Name",
        :phone => "040-34 10 00",
        :fax => "MyString",
        :address => "MyString",
        :post_code => "MyString",
        :postal_town => "Malmö",
        :type_of_housings => [],
        :owner_type => nil,
        :target_groups => [],
        :guaranteed_seats => 1,
        :movable_seats => 1,
        :languages => [],
        :comment => "MyComment"
      ),
      Home.create!(
      :name => "Name 2",
      :phone => "040-34 10 00",
      :fax => "MyString",
      :address => "MyString",
      :post_code => "MyString",
      :postal_town => "Malmö",
      :type_of_housings => [],
      :owner_type => nil,
      :target_groups => [],
      :guaranteed_seats => 1,
      :movable_seats => 1,
      :languages => [],
      :comment => "MyComment"
      )
    ])
  end

  it "renders a list of homes" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 1
    assert_select "tr>td", :text => "Name 2".to_s, :count => 1
    assert_select "tr>td", :text => "Malmö".to_s, :count => 2
    # assert_select "tr>td", :text => "040-34 10 00".to_s, :count => 2
    # assert_select "tr>td", :text => "Fax".to_s, :count => 2
    # assert_select "tr>td", :text => "Address".to_s, :count => 2
    # assert_select "tr>td", :text => "Post Code".to_s, :count => 2
    # assert_select "tr>td", :text => nil.to_s, :count => 2
    # assert_select "tr>td", :text => nil.to_s, :count => 2
    # assert_select "tr>td", :text => nil.to_s, :count => 2
    # assert_select "tr>td", :text => 1.to_s, :count => 2
    # assert_select "tr>td", :text => 2.to_s, :count => 2
    # assert_select "tr>td", :text => 3.to_s, :count => 2
    # assert_select "tr>td", :text => nil.to_s, :count => 2
    # assert_select "tr>td", :text => "MyComment".to_s, :count => 2
  end
end
