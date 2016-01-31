require 'rails_helper'

RSpec.describe "refugees/search", type: :view do
  before(:each) do
    assign(:refugees, [
      Refugee.create!(
        :name => "Name",
        :dossier_number => "123456",
        :comment => "Comment"
      ),
      Refugee.create!(
        :name => "Name 2",
        :dossier_number => "123456",
        :comment => "Comment"
      )
    ])
  end

  it "renders a list of refugees" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 1
    assert_select "tr>td", :text => "Name 2".to_s, :count => 1
    assert_select "tr>td", :text => "123456".to_s, :count => 2
  end
end
