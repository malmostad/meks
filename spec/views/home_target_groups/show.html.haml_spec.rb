require 'rails_helper'

RSpec.describe "home_target_groups/show", type: :view do
  before(:each) do
    @home_target_group = assign(:home_target_group, HomeTargetGroup.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
