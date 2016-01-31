require 'rails_helper'

RSpec.describe "homes/new", type: :view do
  before(:each) do
    assign(:home, Home.new(
      :name => "MyString",
      :phone => "MyString",
      :fax => "MyString",
      :address => "MyString",
      :post_code => "MyString",
      :postal_town => "MyString",
      :type_of_housing => nil,
      :owner_type => nil,
      :target_group => nil,
      :seats => 1,
      :guaranteed_seats => 1,
      :movable_seats => 1,
      :languages => "MyString",
      :comment => "MyText"
    ))
  end

  it "renders new home form" do
    render

    assert_select "form[action=?][method=?]", homes_path, "post" do

      assert_select "input#home_name[name=?]", "home[name]"

      assert_select "input#home_phone[name=?]", "home[phone]"

      assert_select "input#home_fax[name=?]", "home[fax]"

      assert_select "input#home_address[name=?]", "home[address]"

      assert_select "input#home_post_code[name=?]", "home[post_code]"

      assert_select "input#home_postal_town[name=?]", "home[postal_town]"

      assert_select "input#home_type_of_housing_id[name=?]", "home[type_of_housing_id]"

      assert_select "input#owner_type_id[name=?]", "home[owner_type_id]"

      assert_select "input#target_group_id[name=?]", "home[target_group_id]"

      assert_select "input#home_seats[name=?]", "home[seats]"

      assert_select "input#home_guaranteed_seats[name=?]", "home[guaranteed_seats]"

      assert_select "input#home_movable_seats[name=?]", "home[movable_seats]"

      assert_select "input#home_languages[name=?]", "home[languages]"

      assert_select "textarea#home_comment[name=?]", "home[comment]"
    end
  end
end
