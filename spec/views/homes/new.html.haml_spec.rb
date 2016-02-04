require 'rails_helper'

RSpec.describe "homes/new", type: :view do
  before(:each) do
    assign(:home, build(:home))
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
      assert_select "input#home_type_of_housings[name=?]", nil
      assert_select "input#home_owner_types[name=?]", nil
      assert_select "input#home_target_group[name=?]", nil
      assert_select "input#home_guaranteed_seats[name=?]", "home[guaranteed_seats]"
      assert_select "input#home_movable_seats[name=?]", "home[movable_seats]"
      assert_select "input#home_languages[name=?]", nil
      assert_select "textarea#home_comment[name=?]", "home[comment]"
    end
  end
end
