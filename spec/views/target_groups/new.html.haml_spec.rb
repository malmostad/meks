require 'rails_helper'

RSpec.describe "target_group/new", type: :view do
  before(:each) do
    assign(:target_group, TargetGroup.new(
      :name => "MyString"
    ))
  end

  it "renders new target_group form" do
    render

    assert_select "form[action=?][method=?]", target_group_path, "post" do

      assert_select "input#home_target_group_name[name=?]", "home_target_group[name]"
    end
  end
end
