require 'rails_helper'

RSpec.describe "type_of_housings/new", type: :view do
  before(:each) do
    assign(:type_of_housing, TypeOfHousing.new(
      :name => "MyString"
    ))
  end

  it "renders new type_of_housing form" do
    render

    assert_select "form[action=?][method=?]", type_of_housings_path, "post" do

      assert_select "input#type_of_housing_name[name=?]", "type_of_housing[name]"
    end
  end
end
