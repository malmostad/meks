require 'rails_helper'

RSpec.describe "refugees/index", type: :view do
  before(:each) do
    assign(:refugees, [
      Refugee.create!(
        :name => "Name",
        :deregistered_reason => "MyText",
        :special_needs => false,
        :comment => "MyText",
        :gender => nil,
        :home => nil,
        :countries => nil,
        :ssns => nil,
        :dossier_numbers => nil
      ),
      Refugee.create!(
        :name => "Name",
        :deregistered_reason => "MyText",
        :special_needs => false,
        :comment => "MyText",
        :gender => nil,
        :home => nil,
        :countries => nil,
        :ssns => nil,
        :dossier_numbers => nil
      )
    ])
  end

  it "renders a list of refugees" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
