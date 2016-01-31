require 'rails_helper'

RSpec.describe "owner_types/new", type: :view do
  before(:each) do
    assign(:home_owner_type, OwnerType.new(
      :name => "MyString"
    ))
  end

  it "renders new home_owner_type form" do
    render

    assert_select "form[action=?][method=?]", owner_types_path, "post" do

      assert_select "input#home_owner_type_name[name=?]", "home_owner_type[name]"
    end
  end
end
