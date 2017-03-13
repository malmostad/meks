require 'rails_helper'

RSpec.describe "refugees/edit", type: :view do
  before(:each) do
    @refugee = assign(:refugee, create(:refugee))
  end

  it "renders the edit refugee form" do
    render

    assert_select "form[action=?][method=?]", refugee_path(@refugee), "post" do
      assert_select "input#refugee_name[name=?]", "refugee[name]"
      assert_select "input#refugee_date_of_birth[name=?]", "refugee[date_of_birth]"
      assert_select "input#refugee_ssn_extension[name=?]", "refugee[ssn_extension]"
      assert_select "select#refugee_deregistered_reason_id[name=?]", "refugee[deregistered_reason_id]"
      assert_select "select#refugee_special_needs[name=?]", 'refugee[special_needs]'
    end
  end
end
