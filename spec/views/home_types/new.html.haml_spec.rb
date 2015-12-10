require 'rails_helper'

RSpec.describe "home_types/new", type: :view do
  before(:each) do
    assign(:home_type, HomeType.new(
      :name => "MyString"
    ))
  end

  it "renders new home_type form" do
    render

    assert_select "form[action=?][method=?]", home_types_path, "post" do

      assert_select "input#home_type_name[name=?]", "home_type[name]"
    end
  end
end
