require 'rails_helper'

RSpec.describe "legal_codes/index", type: :view do
  before(:each) do
    @legal_codes = assign(:legal_codes, create_list(:legal_code, 2))
  end

  it "renders a list of legal_codes" do
    render
    assert_select "tr>td", :text => @legal_codes.first.name, :count => 1
    assert_select "tr>td", :text => @legal_codes.second.name, :count => 1
  end
end
