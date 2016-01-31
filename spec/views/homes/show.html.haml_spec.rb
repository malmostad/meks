require 'rails_helper'

RSpec.describe "homes/show", type: :view do
  before(:each) do
    @home = assign(:home, Home.create!(
      :name => "Name",
      :phone => "040-34 10 00",
      :postal_town => "Malmö",
      :guaranteed_seats => "12"
    ))
  end

  it "renders attributes in <div>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/040-34 10 00/)
    expect(rendered).to match(/Malmö/)
    expect(rendered).to match(/12/)
  end
end
