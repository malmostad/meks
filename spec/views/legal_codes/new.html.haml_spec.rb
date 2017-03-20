require 'rails_helper'

RSpec.describe "legal_codes/new", type: :view do
  before(:each) do
    assign(:legal_code, build(:legal_code))
  end

  it "renders new legal_code form" do
    render

    assert_select "form[action=?][method=?]", legal_codes_path, "post" do
      assert_select "input#legal_code_name[name=?]", "legal_code[name]"
    end
  end
end
