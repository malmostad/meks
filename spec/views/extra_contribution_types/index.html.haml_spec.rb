RSpec.describe 'extra_contribution_types/index', type: :view do
  before(:each) do
    @extra_contribution_types = assign(:extra_contribution_types, create_list(:extra_contribution_type, 2))
  end

  it 'renders a list of extra_contribution_types' do
    render
    assert_select 'tr>td', text: @extra_contribution_types.first.name.to_s, count: 1
    assert_select 'tr>td', text: @extra_contribution_types.second.name.to_s, count: 1
  end
end
