require 'rails_helper'

RSpec.describe "home_target_groups/edit", type: :view do
  before(:each) do
    @home_target_group = assign(:home_target_group, HomeTargetGroup.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit home_target_group form" do
    render

    assert_select "form[action=?][method=?]", home_target_group_path(@home_target_group), "post" do

      assert_select "input#home_target_group_name[name=?]", "home_target_group[name]"
    end
  end
end
