require 'rails_helper'

RSpec.describe "reports/index", type: :view do
  before(:each) do
    assign(:homes, [
      Home.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of report forms" do
    render
    assert_select "h2", :text => "Placeringar".to_s, :count => 1

    assert_select "h2", :text => "Ensamkommande barn".to_s, :count => 1
    assert_select "#refugees_registered_from", :value => DateTime.now.beginning_of_quarter.to_s, :count => 1
    assert_select "#refugees_registered_to", :value => DateTime.now.to_s, :count => 1
    assert_select "select#refugees_asylum", :name => "refugees_asylum".to_s, :count => 1

    assert_select "h2", :text => "Boenden".to_s, :count => 1
    assert_select "select#homes_free_seats", :text => "Alla".to_s, :count => 0
    assert_select "select#homes_owner_type", :text => "Alla".to_s, :count => 1
  end
end
