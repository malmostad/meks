require 'rails_helper'

RSpec.describe "home_target_groups/new", type: :view do
  before(:each) do
    assign(:home_target_group, HomeTargetGroup.new(
      :name => "MyString"
    ))
  end

  it "renders new home_target_group form" do
    render

    assert_select "form[action=?][method=?]", home_target_groups_path, "post" do

      assert_select "input#home_target_group_name[name=?]", "home_target_group[name]"
    end
  end
end
