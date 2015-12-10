require 'rails_helper'

RSpec.describe "home_owner_types/show", type: :view do
  before(:each) do
    @home_owner_type = assign(:home_owner_type, HomeOwnerType.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
