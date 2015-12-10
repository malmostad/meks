require 'rails_helper'

RSpec.describe "home_types/edit", type: :view do
  before(:each) do
    @home_type = assign(:home_type, HomeType.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit home_type form" do
    render

    assert_select "form[action=?][method=?]", home_type_path(@home_type), "post" do

      assert_select "input#home_type_name[name=?]", "home_type[name]"
    end
  end
end
