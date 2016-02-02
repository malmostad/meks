require 'rails_helper'

RSpec.describe "moved_out_reasons/index", type: :view do
  before(:each) do
    assign(:moved_out_reasons, [
      MovedOutReason.create!(
        :name => "Name"
      ),
      MovedOutReason.create!(
        :name => "Name 2"
      )
    ])
  end

  it "renders a list of moved_out_reasons" do
    render
    assert_select "tr>td", :text => "Name", :count => 1
    assert_select "tr>td", :text => "Name 2", :count => 1
  end
end
