require 'rails_helper'

RSpec.describe "refugees/new", type: :view do
  before(:each) do
    assign(:refugee, build(:refugee))
  end

  it "renders new refugee form" do
    render

    assert_select "form[action=?][method=?]", refugees_path, "post" do
      assert_select "input#refugee_name[name=?]", "refugee[name]"
      assert_select "select#refugee_deregistered_reason_id[name=?]", "refugee[deregistered_reason_id]"
      assert_select "input#refugee_special_needs[name=?]", false
    end
  end
end
