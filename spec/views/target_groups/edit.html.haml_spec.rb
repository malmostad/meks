require 'rails_helper'

RSpec.describe "target_groups/edit", type: :view do
  before(:each) do
    @target_group = assign(:target_group, TargetGroup.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit target_group form" do
    render

    assert_select "form[action=?][method=?]", target_group_path(@target_group), "post" do

      assert_select "input#target_group_name[name=?]", "target_group[name]"
    end
  end
end
