require 'rails_helper'

RSpec.describe "homes/show", type: :view do
  before(:each) do
    @home = assign(:home, create(:home))
  end

  it "renders attributes for home" do
    render
    expect(rendered).to match(/#{@home.name}/)
    expect(rendered).to match(/#{@home.phone}/)
    expect(rendered).to match(/#{@home.postal_town}/)
    expect(rendered).to match(/#{@home.post_code}/)
  end
end
