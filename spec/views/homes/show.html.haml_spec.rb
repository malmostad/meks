require 'rails_helper'

RSpec.describe "homes/show", type: :view do
  before(:each) do
    @home = assign(:home, Home.create!(
      :name => "Name",
      :phone => "Phone",
      :fax => "Fax",
      :address => "Address",
      :post_code => "Post Code",
      :postal_town => "Postal Town",
      :home_type => nil,
      :home_owner_type => nil,
      :home_target_group => nil,
      :seats => 1,
      :guaranteed_seats => 2,
      :movable_seats => 3,
      :languages => "Languages",
      :comment => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/Fax/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/Post Code/)
    expect(rendered).to match(/Postal Town/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Languages/)
    expect(rendered).to match(/MyText/)
  end
end
