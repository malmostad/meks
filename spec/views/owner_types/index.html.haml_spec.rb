RSpec.describe 'owner_types/index', type: :view do
  before(:each) do
    @owner_types = assign(:owner_types, create_list(:owner_type, 2))
  end

  it 'renders a list of owner_types' do
    render
    assert_select 'tr>td', text: @owner_types.first.name.to_s, count: 1
    assert_select 'tr>td', text: @owner_types.second.name.to_s, count: 1
  end
end
