require 'rails_helper'

RSpec.describe "home_owner_types/edit", type: :view do
  before(:each) do
    @home_owner_type = assign(:home_owner_type, HomeOwnerType.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit home_owner_type form" do
    render

    assert_select "form[action=?][method=?]", home_owner_type_path(@home_owner_type), "post" do

      assert_select "input#home_owner_type_name[name=?]", "home_owner_type[name]"
    end
  end
end
