require 'rails_helper'

RSpec.describe "moved_out_reasons/new", type: :view do
  before(:each) do
    assign(:moved_out_reason, MovedOutReason.new(
      :name => "MyString"
    ))
  end

  it "renders new moved_out_reason form" do
    render

    assert_select "form[action=?][method=?]", moved_out_reasons_path, "post" do

      assert_select "input#moved_out_reason_name[name=?]", "moved_out_reason[name]"
    end
  end
end
