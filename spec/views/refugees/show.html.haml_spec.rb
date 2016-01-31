require 'rails_helper'

RSpec.describe "refugees/show", type: :view do
  before(:each) do
    @refugee = assign(:refugee, Refugee.create!(
      :name => "Name",
      :deregistered_reason => "MyText",
      :comment => "MyText",
      :gender => nil,
      :homes => [],
      :countries => [],
      :dossier_number => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
