RSpec.describe 'homes/index', type: :view do
  before(:each) do
    @homes = assign(:homes, create_list(:home, 2))
  end

  it 'renders a list of homes' do
    render
    assert_select 'tr>td', text: 'Lägg till', count: 0
    assert_select 'tr>td', text: @homes.first.name, count: 1
    assert_select 'tr>td', text: @homes.second.name, count: 1
  end
end
