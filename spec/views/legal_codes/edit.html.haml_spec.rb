require 'rails_helper'

RSpec.describe "legal_codes/edit", type: :view do
  before(:each) do
    @legal_code = assign(:legal_code, create(:legal_code))
  end

  it "renders the edit legal_code form" do
    render

    assert_select "form[action=?][method=?]", legal_code_path(@legal_code), "post" do
      assert_select "input#legal_code_name[name=?]", "legal_code[name]"
    end
  end
end
